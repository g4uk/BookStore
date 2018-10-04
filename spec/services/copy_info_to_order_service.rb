require 'rails_helper'

RSpec.describe CopyInfoToOrderService do
  let(:cart) { create(:cart) }
  let(:order) { create(:order) }
  let(:user) { create(:user) }
  subject(:returned_order) { CopyInfoToOrderService.new(cart: cart, order: order, user: user).call }

  it 'copy items to order' do
    order.order_items.clear
    cart.order_items.each do |item|
      order_item = item.dup
      order.order_items << order_item
    end
    expect(returned_order.order_items).to eql(order.order_items)
  end

  it 'copy addresses to order' do
    order.billing_address = user.billing_address.dup
    order.shipping_address = user.shipping_address.dup
    expect(returned_order.billing_address).to eql(order.billing_address)
    expect(returned_order.shipping_address).to eql(order.shipping_address)
  end

  it 'assigns order attributes' do
    total = CartUtilsService.total_price(cart)
    expect(returned_order.user).to eql(user)
    expect(returned_order.total).to eql(total)
  end
end
