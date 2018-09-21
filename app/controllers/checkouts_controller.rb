class CheckoutsController < ApplicationController
  include Wicked::Wizard

  layout 'main'

  before_action :set_order, :decorate_objects

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    build_associated_objects
    render_wizard
  end

  def update
    already_paid = @order.payment?
    case step
    when :address
      if already_paid
        jump_to(:confirm) if @order.update(order_params)
      end
      if @order.may_fill_address?
        @order.assign_attributes(order_params)
        @order.shipping_address.assign_attributes(order_params[:billing_address_attributes]) if order_params[:billing_flag]
        @order.fill_address! if @order.save
      end
    when :delivery
      if already_paid
        update_delivery_info
        jump_to(:confirm)
      end
      if @order.may_fill_delivery?
        @order.fill_delivery! if update_delivery_info
      end
    when :payment
      @order.assign_attributes(order_params)
      @order.credit_card.number = CreditCardNumberService.call(order_params)
      if already_paid
        jump_to(:confirm) if @order.save
      end
      if @order.may_fill_payment?
        if @order.save
          @cart.destroy
          @order.fill_payment!
        end
      end
    when :confirm
      if @order.may_confirm?
        @order.confirm!
        ApplicationMailer.order_email(current_user.email, @order.id).deliver
      end
    end
    render_wizard @order
  end

  private

  def order_params
    params.require(:order).permit(:delivery_id, :billing_flag,
                                  billing_address_attributes: %i[first_name last_name address city zip country phone],
                                  shipping_address_attributes: %i[first_name last_name address city zip country phone],
                                  credit_card_attributes: %i[number owner_name expiration_date cvv])
  end

  def set_order
    @order = Order.find(session[:order_id])
  rescue ActiveRecord::RecordNotFound
    @order = Order.new
  end

  def decorate_objects
    @cart = @cart.decorate
    @order = @order.decorate
    @countries_with_codes = CountriesListService.call
    @deliveries = Delivery.all.decorate
    @order_items = @order.order_items
    @billing_address = AddressDecorator.decorate(@order.billing_address)
    @shipping_address = AddressDecorator.decorate(@order.shipping_address)
  end

  def build_associated_objects
    @order.build_billing_address if @order.billing_address.blank?
    @order.build_shipping_address if @order.shipping_address.blank?
    @order.build_credit_card if @order.credit_card.blank?
  end

  def update_delivery_info
    delivery = Delivery.find(order_params[:delivery_id])
    @order.update_attributes(delivery_id: delivery.id,
                                 delivery_type: delivery.name,
                                 delivery_price: delivery.price,
                                 delivery_duration: delivery.duration)
  end
end
