class CreateOrderService
  def initialize(cart:, user:, order:)
    @cart = cart
    @user = user
    @order = order
  end

  def call
    saved_order = fill_order
    checkout if saved_order
    saved_order
  end

  private

  def fill_order
    CopyInfoToOrderService.new(cart: @cart, order: @order, user: @user).call
  end

  def checkout
    @order.checkout! if @order.may_checkout?
  end
end
