# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookDecorator do
  include ActionView::Helpers::NumberHelper

  let(:book) { create(:book).decorate }

  it 'formats authors' do
    book_authors = book.authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
    expect(book.formatted_authors).to eql(book_authors)
  end

  it 'formats price' do
    price = number_to_currency(book.price, precizion: 2)
    expect(book.formatted_price).to eql(price)
  end

  it 'truncates description for order items' do
    description = book.description.truncate(150).html_safe
    expect(book.short_description(150)).to eql(description)
  end
end
