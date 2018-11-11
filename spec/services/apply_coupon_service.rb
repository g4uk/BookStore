# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplyCouponService do
  let(:cart) { create(:cart) }
  let(:coupon) { create(:coupon) }
  let(:code) { coupon.code }

  it 'updates cart' do
    cart.update(coupon_code: code, coupon_price: coupon.discount)
    ApplyCouponService.new(cart: cart, code: code).call
    expect(cart.coupon_code).to eql(code)
  end
end
