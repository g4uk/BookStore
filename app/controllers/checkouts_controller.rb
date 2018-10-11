class CheckoutsController < ApplicationController
  include Wicked::Wizard

  layout 'main'

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
      jump_to(:confirm) if already_paid && @order.update(order_params)
      FillAddressesService.call(order: @order, order_params: order_params)
    when :delivery
      UpdateOrdersDeliveryInfoService.call(order: @order, order_params: order_params)
      jump_to(:confirm) if already_paid
    when :payment
      @order = PaymentService.call(order: @order, order_params: order_params, cart: @cart)
      jump_to(:confirm) if already_paid && @order.save
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

  def set_order_with_items
    @order = Order.includes(order_items: [:book, image_attachment: :blob]).find(session[:order_id]).decorate
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

  rescue_from(ActionController::ParameterMissing) do
    flash[:notice] = 'You should to choose shipping method'
    redirect_to wizard_path
  end
end
