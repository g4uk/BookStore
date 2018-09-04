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

    def sort_popular(books)
      grouped_books = {}
      i = 0
      while i < books.size
        grouped_books[books[i]] = books[i].order_items.sum(&:quantity)
        i += 1
      end
      sorted_books = grouped_books.sort_by { |_key, value| value }.reverse.to_h
      BookDecorator.decorate_collection(sorted_books.keys)
    end
  end
end
