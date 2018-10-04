require 'rails_helper'

RSpec.describe BookDecorator do
  include ActionView::Helpers::NumberHelper

  let(:cart) { create(:cart).decorate }
  let(:coupon_price) { create(:coupon).discount }

  it 'formats subtotal' do
    subtotal = number_to_currency(CartUtilsService.subtotal(cart.order_items), precizion: 2)
    expect(cart.formatted_subtotal).to eql(subtotal)
  end

  it 'formats discount' do
    cart.coupon_price = coupon_price
    cart.decorate
    discount = number_to_currency(coupon_price, precizion: 2)
    expect(cart.formatted_discount).to eql(discount)
  end

  it 'formats total' do
    total = number_to_currency(CartUtilsService.total_price(cart), precizion: 2)
    expect(cart.formatted_total).to eql(total)
  end

  it 'gets total_quantity' do
    total = CartUtilsService.total_quantity(cart.order_items)
    expect(cart.total_quantity).to eql(total)
  end
end
