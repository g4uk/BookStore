class CartUtilsService
  class << self
    def subtotal(order_items)
      order_items.to_a.sum(&:total)
    end

    def total_price(cart)
      coupon_price = cart.coupon_price
      subtotal = subtotal(cart.order_items)
      coupon_price ? subtotal - coupon_price : subtotal
    end

    def total_quantity(order_items)
      order_items.to_a.sum(&:quantity)
    end

    def item_total_price(order_item)
      order_item.book_price * order_item.quantity
    end
  end
end
