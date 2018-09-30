class CopyInfoToOrderService
  def initialize(cart:, order:, user:)
    @cart = cart
    @order = order
    @user = user
  end

  def call
    @order.assign_attributes(user: @user, total: CartUtilsService.total_price(@cart))
    fill_with_items
    @order.billing_address = @user.billing_address.dup if @user.billing_address
    @order.shipping_address = @user.shipping_address.dup if @user.shipping_address
    @order
  end

  private

  def fill_with_items
    @order.order_items.clear
    @cart.order_items.each do |item|
      order_item = item.dup
      order_item.image.attach(item.image.blob) if item.image.attached?
      @order.order_items << order_item
    end
  end
end
