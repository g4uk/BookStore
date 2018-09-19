class CartDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_subtotal
    number_to_currency(subtotal, precizion: 2)
  end

  def formatted_discount
    number_to_currency(coupon_price, precizion: 2)
  end

  def formatted_total
    number_to_currency(total_price, precizion: 2)
  end

  def subtotal
    order_items.to_a.sum(&:total)
  end

  def total_price
    return subtotal - coupon_price if coupon_price
    subtotal
  end

  def total_quantity
    order_items.to_a.sum(&:quantity)
  end
end
