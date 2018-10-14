class CheckoutsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :set_order, :decorate_objects

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    case step
    when :confirm
      set_order_with_items
    when :complete
      set_order_with_items
    end
    build_associated_objects
    render_wizard
  end

  def update
    already_paid = @order.payment?
    case step
    when :address
      FillAddressesService.new(order: @order, order_params: order_params).call
      jump_to(:confirm) if already_paid
    when :delivery
      UpdateOrdersDeliveryInfoService.new(order: @order, order_params: order_params).call
      jump_to(:confirm) if already_paid
    when :payment
      PaymentService.new(order: @order, order_params: order_params, cart: @cart).call
      jump_to(:confirm) if already_paid
    when :confirm
      ConfirmOrderService.new(user: current_user, order: @order).call
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
    @order = Order.find_or_initialize_by(id: session[:order_id]).decorate
  end

  def set_order_with_items
    @order = Order.includes(order_items: [:book, image_attachment: :blob]).find(session[:order_id]).decorate
  end

  def decorate_objects
    @order = @order.decorate
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

  rescue_from(ActionController::ParameterMissing) do
    redirect_to wizard_path, notice: 'You should to choose shipping method'
  end
end
