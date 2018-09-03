class CheckoutsController < ApplicationController
  include CurrentCart
  include CurrentOrder
  include Wicked::Wizard

  layout 'main'

  before_action :set_order, :set_cart

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    puts "+++++++++++++++++++++++"
    p @order
    p @order.billing_address
    puts "+++++++++++++++++++++++"
    @order.build_billing_address if @order.billing_address.blank?
    @order.build_shipping_address if @order.shipping_address.blank?
    @order.build_credit_card if @order.credit_card.blank?
    @deliveries = Delivery.all
    p @order.billing_address
    render_wizard
  end

  def update
    case step
    when :address
      if @order.confirmed?
        @order.update(order_params)
        redirect_to wizard_path(:confirm)
      end
      if @order.may_fill_address?
        p order_params[:shipping_address_attributes][:first_name].blank?
        p order_params[:shipping_address_attributes] = order_params[:billing_address_attributes] if order_params[:shipping_address_attributes][:first_name].blank?
        p order_params
        @order.fill_address! if @order.update(order_params)
        render_wizard @order if @order.shipping?
      end
    when :delivery
      delivery = Delivery.find(order_params[:delivery_id])
      if @order.confirmed?
        @order.update_attributes(delivery_id: delivery.id,
                                 delivery_type: delivery.name,
                                 delivery_price: delivery.price,
                                 delivery_duration: delivery.duration)
        redirect_to wizard_path(:confirm)
      end
      if @order.may_fill_delivery?
        @order.fill_delivery! if @order.update_attributes(delivery_id: delivery.id,
                                                          delivery_type: delivery.name,
                                                          delivery_price: delivery.price,
                                                          delivery_duration: delivery.duration)
        render_wizard @order if @order.payment?
      end
    when :payment
      if @order.confirmed?
        @order.update(order_params)
        redirect_to wizard_path(:confirm)
      end
      if @order.may_fill_payment?
        @order.fill_payment! if @order.update(order_params)
        render_wizard @order if @order.confirmed?
      end
    when :confirm
      if @order.may_confirm?
        @order.confirm!
        render_wizard @order
      end
    end
    render_wizard @order
  end

  private

  def order_params
    params.require(:order).permit(:delivery_id,
                                  billing_address_attributes: %i[first_name last_name address city zip country phone],
                                  shipping_address_attributes: %i[first_name last_name address city zip country phone],
                                  credit_card_attributes: %i[number owner_name expiration_date cvv])
  end
end
