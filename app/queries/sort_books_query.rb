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
    books_with_order_items
    @books = by_category if @category_id
    books_sorted_by_order_items_quantity
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
    @books = Kaminari.paginate_array(@books).page(@page).per(BOOKS_ON_PAGE)
  end

  def books_sorted_by_order_items_quantity
    @books = PopularBooksService.new.group_by_order_items_quantity(@books).keys
  end

  def books_with_order_items
    @books = Book.includes(:order_items, :authors, :books_authors, images: [photo_attachment: :blob])
  end

  def books_without_order_items
    @books = Book.includes(:authors, :books_authors, images: [photo_attachment: :blob])
  end
end
