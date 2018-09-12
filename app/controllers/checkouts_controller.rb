class CheckoutsController < ApplicationController
  include Wicked::Wizard

  layout 'main'

  before_action :set_order

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    @order.build_billing_address if @order.billing_address.blank?
    @order.build_shipping_address if @order.shipping_address.blank?
    @order.build_credit_card if @order.credit_card.blank?
    @deliveries = Delivery.all
    render_wizard
  end

  def update
    case step
    when :address
      if @order.in_queue?
        @order.update(order_params)
        redirect_to wizard_path(:confirm)
      end
      if @order.may_fill_address?
        order_params[:shipping_address_attributes] = order_params[:billing_address_attributes] if order_params[:shipping_address_attributes][:first_name].blank?
        @order.fill_address! if @order.update(order_params)
        render_wizard @order if @order.shipping?
      end
    when :delivery
      delivery = Delivery.find(order_params[:delivery_id])
      if @order.in_queue?
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
        render_wizard @order if @order.in_progress?
      end
    when :payment
      if @order.in_queue?
        @order.update(order_params)
        redirect_to wizard_path(:confirm)
      end
      if @order.may_fill_payment?
        @order.fill_payment! if @order.update(order_params)
        render_wizard @order if @order.payment?
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

  def set_order
    @order = Order.find(session[:order_id])
  rescue ActiveRecord::RecordNotFound
    @order = Order.new
  end
end
