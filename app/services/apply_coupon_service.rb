# frozen_string_literal: true

class ApplyCouponService < Rectify::Command
  def initialize(code:, cart:)
    @coupon = Coupon.find_by(code: code)
    @cart = cart
  end

  def call
    if @coupon
      apply_coupon
      broadcast(:ok)
    else
      broadcast(:invalid)
    end
  end

  private

  def apply_coupon
    @cart.update(coupon_code: @coupon.code, coupon_price: @coupon.discount)
  end
end
