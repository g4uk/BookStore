require 'rails_helper'

RSpec.describe SortedBooksService do
  let(:category) { create(:category_with_books) }

  before do
    @books = category.books
  end

  describe 'sort by title' do
    it 'sorts by title A-Z' do
      sort_params = 'title asc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end

    it 'sorts by title Z-A' do
      sort_params = 'title desc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end
  end

  describe 'sort by created_at' do
    it 'sorts by created_at asc' do
      sort_params = 'created_at asc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end

    it 'sorts by created_at desc' do
      sort_params = 'created_at desc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end
  end

  describe 'sort by price' do
    it 'sorts by price asc' do
      sort_params = 'price asc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end

    it 'sorts by price desc' do
      sort_params = 'price desc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: nil, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end
  end

  describe 'sort in category' do
    it 'sorts by title A-Z' do
      sort_params = 'title asc'
      sorted_books = SortedBooksService.new(sort_params: sort_params, category_id: category.id, page: '1').call
      expect(sorted_books.to_a).to eql(@books.order(sort_params).to_a)
    end
  end
end
