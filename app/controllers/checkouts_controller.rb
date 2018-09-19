class CheckoutsController < ApplicationController
  include Wicked::Wizard

  layout 'main'

  before_action :set_order, :decorate_objects

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    @order.build_billing_address if @order.billing_address.blank?
    @order.build_shipping_address if @order.shipping_address.blank?
    @order.build_credit_card if @order.credit_card.blank?
    @deliveries = DeliveryDecorator.decorate_collection(Delivery.all)
    @order_items = OrderItemDecorator.decorate_collection(@order.order_items)
    render_wizard
  end

  def update
    case step
    when :address
      if @order.payment?
        jump_to(:confirm) if @order.update(order_params)
      end
      if @order.may_fill_address?
        @order.assign_attributes(order_params)
        @order.shipping_address.assign_attributes(order_params[:billing_address_attributes]) if order_params[:billing_flag]
        @order.fill_address! if @order.save
      end
    when :delivery
      delivery = Delivery.find(order_params[:delivery_id])
      if @order.payment?
        @order.update_attributes(delivery_id: delivery.id,
                                 delivery_type: delivery.name,
                                 delivery_price: delivery.price,
                                 delivery_duration: delivery.duration)
        jump_to(:confirm)
      end
      if @order.may_fill_delivery?
        @order.fill_delivery! if @order.update_attributes(delivery_id: delivery.id,
                                                          delivery_type: delivery.name,
                                                          delivery_price: delivery.price,
                                                          delivery_duration: delivery.duration)
      end
    when :payment
      if @order.payment?
        number = order_params[:credit_card_attributes][:number].last(4)
        @order.assign_attributes(order_params)
        @order.credit_card.number = number
        jump_to(:confirm) if @order.save
      end
      if @order.may_fill_payment?
        number = order_params[:credit_card_attributes][:number].last(4)
        @order.assign_attributes(order_params)
        @order.credit_card.number = number
        @order.fill_payment! if @order.save
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
  end
end
