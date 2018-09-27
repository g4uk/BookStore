class CartUtilsService
  class << self
    def subtotal(order_items)
      order_items.to_a.sum(&:total)
    end

    def total_price(cart)
      coupon_price = cart.coupon_price
      coupon_price ? subtotal(cart.order_items) - coupon_price : subtotal(cart.order_items)
    end

    def total_quantity(order_items)
      order_items.to_a.sum(&:quantity)
    end

    def item_total_price(order_item)
      order_item.book_price * order_item.quantity
    end
  end
end
