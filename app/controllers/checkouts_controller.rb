# frozen_string_literal: true

class CheckoutsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :set_order

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    return redirect_to cart_path(@cart) unless @order
    @order_presenter = OrderPresenter.new(@order)
    build_associated_objects
    CheckoutStepService.call(order: @order, step: step) { on(:ok) { |current_step| jump_to(current_step) } }
    render_wizard
  end

  def update
    if step.eql?(:confirm)
      ConfirmOrderService.new(user: current_user, order: @order).call
    else
      @order = CheckoutService.new(order: @order, params: order_params, user: current_user, cart: @cart, step: step).call
      jump_to(:confirm) if @order.payment?
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
    @order = FindOrderQuery.new(order_id: session[:order_id], step: step).call
  end

  rescue_from(ActionController::ParameterMissing) do
    redirect_to wizard_path, notice: t('notice.choose_delivery')
  end

  def build_associated_objects
    @order.build_billing_address if @order.billing_address.blank?
    @order.build_shipping_address if @order.shipping_address.blank?
    @order.build_credit_card if @order.credit_card.blank?
  end
end
