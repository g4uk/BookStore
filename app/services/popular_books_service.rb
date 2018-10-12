class PopularBooksService
  def initialize
    @grouped_by_category = {}
  end

  def call
    books = Book.includes(:order_items, :authors, :books_authors, images: [photo_attachment: :blob])
    group_by_category(books)
    BookDecorator.decorate_collection(@grouped_by_category.values.first(4))
  end

  def group_by_order_items_quantity(books)
    grouped_books = {}
    books.each { |book| grouped_books[book] = book.order_items.sum(&:quantity) }
    grouped_books.sort_by { |_book, order_items_number| order_items_number }.reverse.to_h
  end

  private

  def group_by_category(books)
    grouped_books = books.group_by(&:category_id)
    grouped_books.each do |category_id, books_in_category|
      sorted_books = group_by_order_items_quantity(books_in_category)
      @grouped_by_category[category_id] = sorted_books.keys.first
    end
  end
end
