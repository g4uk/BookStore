class PopularBooksService
  def initialize
    @grouped_books = {}
    @sorted_books = {}
    @grouped_by_category = {}
  end

  def call
    books = Book.all.includes(:order_items, :authors, :books_authors, images: [photo_attachment: :blob])
    @grouped_by_category = books.group_by(&:category_id)
    @grouped_by_category.each do |categoty_id, books_in_category|
      group_by_order_items_quantity(books_in_category)
      @grouped_by_category[categoty_id] = @sorted_books.keys.first
    end
    BookDecorator.decorate_collection(@grouped_by_category.values.first(4))
  end

  private

  def group_by_order_items_quantity(books)
    @grouped_books.clear
    books.each do |book|
      @grouped_books[book] = book.order_items.sum(&:quantity)
      @sorted_books = @grouped_books.sort_by { |_book, orders_number| orders_number }.reverse.to_h
    end
  end
end
