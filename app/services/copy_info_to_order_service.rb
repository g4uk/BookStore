class CopyInfoToOrderService
  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    assign_order_attributes
    fill_with_items
    copy_addresses
    @order.save
  end

  private

  def assign_order_attributes
    total = CartUtilsService.total_price(@cart)
    @order.assign_attributes(user: @user, total: total)
  end

  def copy_addresses
    @order.billing_address = @user.billing_address.dup if @user.billing_address
    @order.shipping_address = @user.shipping_address.dup if @user.shipping_address
  end

  def fill_with_items
    @order.order_items.clear
    @cart.order_items.each do |item|
      order_item = item.dup
      order_item.image.attach(item.image.blob) if item.image.attached?
      @order.order_items << order_item
    end
  end
end
