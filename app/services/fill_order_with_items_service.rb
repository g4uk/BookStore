class FillOrderWithItemsService
  class << self
    def call(cart:, order:, user:)
      order.assign_attributes(user: user, total: cart.total_price)
      cart.order_items.each do |item|
        order.order_items << item
      end
      order
    end
  end
end
