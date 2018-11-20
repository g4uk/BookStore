# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewOrderItemService do
  let(:book) { create(:book) }
  let(:cart) { create(:cart) }

  it 'gets three latest books' do
    saved = NewOrderItemService.call(book_id: book.id, quantity: 3, cart: cart)
    expect(saved).to eql(ok: [])
    expect(OrderItem.all.last.book_name).to eql(book.title)
    expect(OrderItem.all.last.quantity).to eql 3
  end
end
