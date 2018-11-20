# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliveryDecorator do
  include ActionView::Helpers::NumberHelper

  let(:cart) { create(:cart) }
  let(:order_item) { cart.order_items.first.decorate }

  it 'formats total' do
    total = number_to_currency(order_item.total, precizion: 2)
    expect(order_item.formatted_total).to eql(total)
  end

  it 'formats book_price' do
    price = number_to_currency(order_item.book_price, precizion: 2)
    expect(order_item.formatted_book_price).to eql(price)
  end

  it 'formats description' do
    description = order_item.book.description.truncate(150).html_safe
    expect(order_item.book_description).to eql(description)
  end
end
