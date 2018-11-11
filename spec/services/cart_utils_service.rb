# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartUtilsService do
  let(:cart) { create(:cart) }
  let(:order_items) { cart.order_items }
  let(:order_item) { cart.order_items.first }
  let(:coupon_price) { create(:coupon).discount }
  let(:subtotal) { order_items.to_a.sum(&:total) }

  it 'calculates subtotal' do
    expect(CartUtilsService.subtotal(order_items)).to eql(subtotal)
  end

  describe '#total_price' do
    context 'without coupon' do
      it 'calculates total_price' do
        expect(CartUtilsService.total_price(cart)).to eql(subtotal)
      end
    end
    context 'with coupon' do
      it 'calculates total_price' do
        cart.coupon_price = coupon_price
        expect(CartUtilsService.total_price(cart)).to eql(subtotal - coupon_price)
      end
    end
  end

  it 'calculates total_quantity' do
    total_quantity = order_items.to_a.sum(&:quantity)
    expect(CartUtilsService.total_quantity(order_items)).to eql(total_quantity)
  end

  it 'calculates total_quantity' do
    total_price = order_item.book_price * order_item.quantity
    expect(CartUtilsService.item_total_price(order_item)).to eql(total_price)
  end
end
