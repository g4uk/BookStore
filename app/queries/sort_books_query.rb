# frozen_string_literal: true

class SortBooksQuery
  BOOKS_ON_PAGE = 12

  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
    @books = {}
  end

  def call
    return by_popularity if @sort_param.eql?('popular')
    books_without_order_items
    by_category
    return by_creation if ['created_at desc', nil].include?(@sort_param)
    by_title_and_price
  end

  private

  def by_category
    @books = @books.where(category_id: @category_id) if @category_id
  end

  def by_popularity
    sort_in_category_by_order_items_quantity if @category_id
    sort_by_order_items_quantity unless @category_id
    paginate
  end

  def by_creation
    @books = @books.newest.to_a
    paginate
  end

  def by_title_and_price
    @books = @books.order(@sort_param)
    paginate
  end

  def paginate
    BookDecorator.decorate_collection(Kaminari.paginate_array(@books).page(@page).per(BOOKS_ON_PAGE))
  end

  def sort_by_order_items_quantity
    @books = Book.find_by_sql('select books.*, sum(order_items.quantity) from books inner join order_items on books.id=order_items.book_id group by books.id order by sum desc;')
    load_associations
  end

  def sort_in_category_by_order_items_quantity
    @books = Book.find_by_sql("select books.*, sum(order_items.quantity) from books inner join order_items on books.id=order_items.book_id where books.category_id=#{@category_id} group by books.id order by sum desc;")
    load_associations
  end

  def books_without_order_items
    @books = Book.includes(:authors, :books_authors, images: [photo_attachment: :blob])
  end

  def load_associations
    ActiveRecord::Associations::Preloader.new.preload(@books, [:authors, :books_authors, images: [photo_attachment: :blob]])
    @books
  end
end
