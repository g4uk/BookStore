# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CopyInfoToOrderService do
  let(:cart) { create(:cart) }
  let(:order) { create(:order) }
  let(:user) { create(:user) }
  subject(:result) { CopyInfoToOrderService.new(cart: cart, order: order, user: user).call }

  it 'copy items to order' do
    order.order_items.clear
    cart.order_items.each do |item|
      order_item = item.dup
      order.order_items << order_item
    end
    expect(result).to eql(true)
  end

  it 'copy addresses to order' do
    order.billing_address = user.billing_address.dup
    order.shipping_address = user.shipping_address.dup
    expect(result).to eql(true)
  end

  it 'assigns order attributes' do
    total = cart.total_price
    expect(result).to eql(true)
  end
end
