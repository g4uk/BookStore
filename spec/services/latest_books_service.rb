require 'rails_helper'

RSpec.describe LatestBooksService do
  let(:category) { create(:category_with_books) }

  before do
    @books = category.books
  end

  it 'gets three latest books' do
    three_latest_books = @books.order('created_at desc').limit(3).to_a
    expect(LatestBooksService.call.to_a).to eql(three_latest_books)
  end
end
