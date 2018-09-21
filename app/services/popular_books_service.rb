class PopularBooksService
  class << self
    def call
      books = Book.all.includes(:order_items, :authors, :books_authors, images: :photo_attachment)
      grouped_by_category = books.group_by(&:category_id)
      grouped_books = {}
      sorted_books = {}
      grouped_by_category.each do |categoty_id, books_in_category|
        books_in_category.each do |book|
          grouped_books.clear
          grouped_books[book] = book.order_items.sum(&:quantity)
          sorted_books = grouped_books.sort_by { |_key, value| value }.reverse.to_h
        end
        grouped_by_category[categoty_id] = sorted_books.keys.first
      end
      BookDecorator.decorate_collection(grouped_by_category.values.first(4))
    end
  end
end
