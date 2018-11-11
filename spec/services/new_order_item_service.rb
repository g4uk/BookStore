# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewOrderItemService do
  let(:book) { create(:book) }
  let(:cart) { create(:cart) }

  it 'gets three latest books' do
    saved = NewOrderItemService.new(book: book, quantity: 3, cart: cart).call
    expect(saved).to eql true
    expect(OrderItem.all.last.book_name).to eql(book.title)
    expect(OrderItem.all.last.quantity).to eql 3
  end
end
