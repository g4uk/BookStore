# frozen_string_literal: true

module CartCalculations
  extend ActiveSupport::Concern

  def subtotal
    order_items.to_a.sum(&:total)
  end

  def total_price
    cart_subtotal = subtotal
    coupon_price ? cart_subtotal - coupon_price : cart_subtotal
  end

  def total_quantity
    order_items.to_a.sum(&:quantity)
  end
end
