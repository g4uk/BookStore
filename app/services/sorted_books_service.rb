class SortedBooksService
  def initialize(sort_params:, category_id:, page:)
    @books_on_page = 12
    @page = page
    @sort_params = sort_params
    @category_id = category_id
  end

  def call
    return sort_popular if @sort_params.eql?('popular')
    books = Book.all.includes(:authors, :books_authors, images: [photo_attachment: :blob])
    books = books.where(category_id: @category_id) if @category_id
    return books.order('created_at desc').page(@page).per(@books_on_page) if @sort_params.eql?(:all)
    books.order(@sort_params).page(@page).per(@books_on_page)
  end

  private

  def sort_popular
    books = books_with_order_items
    books = books.where(category_id: @category_id) if @category_id
    sort_by_orders_quantity(books)
  end

  def sort_by_orders_quantity(books)
    grouped_books = {}
    books.each { |book| grouped_books[book] = book.order_items.sum(&:quantity) }
    sorted_books = grouped_books.sort_by { |_key, value| value }.reverse.to_h
    Kaminari.paginate_array(sorted_books.keys).page(@page).per(@books_on_page)
  end

  def books_with_order_items
    Book.all.includes(:order_items, :authors, :books_authors, images: [photo_attachment: :blob])
  end
end
