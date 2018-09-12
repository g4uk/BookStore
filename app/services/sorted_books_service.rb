class SortedBooksService
  class << self
    def call(sort_params:, books:)
      if sort_params
        return sort_popular(books) if sort_params == 'popular'
        BookDecorator.decorate_collection(books.order(sort_params))
      else
        BookDecorator.decorate_collection(books.order('created_at desc'))
      end
    end
    
    private

    def sort_popular(books)
      grouped_books = {}
      books.each do |book|
        grouped_books[book] = book.order_items.sum(&:quantity)
      end
      sorted_books = grouped_books.sort_by { |_key, value| value }.reverse.to_h
      BookDecorator.decorate_collection(sorted_books.keys)
    end
  end
end
