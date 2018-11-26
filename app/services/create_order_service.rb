# frozen_string_literal: true

class CreateOrderService < Rectify::Command
  def initialize(cart:, user:, order:)
    @cart = cart
    @user = user
    @order = order
  end

  def call
    saved_order = fill_order
    if saved_order
      checkout
      return broadcast(:ok)
    end
    broadcast(:invalid, saved_order.errors.full_messages)
  end

  private

  def fill_order
    CopyInfoToOrderService.new(cart: @cart, order: @order, user: @user).call
  end

  def checkout
    @order.checkout! if @order.may_checkout?
  end
end
