# frozen_string_literal: true

class PopularBooksService
  def initialize
    @grouped_by_category = {}
    @books = {}
  end

  def call
    group_by_category
    decorate_books
  end

  private

  def group_by_order_items_quantity(category_id)
    @books = Book.find_by_sql("select books.*, sum(order_items.quantity) from books inner join order_items on books.id=order_items.book_id where books.category_id=#{category_id} group by books.id order by sum desc;")
    load_associations
  end

  def group_by_category
    Category.select(:id).each do |category|
      sorted_books = group_by_order_items_quantity(category.id)
      @grouped_by_category[category.id] = sorted_books.first
    end
  end

  def load_associations
    ActiveRecord::Associations::Preloader.new.preload(@books, [:authors, :books_authors, images: [photo_attachment: :blob]])
    @books
  end

  def decorate_books
    BookDecorator.decorate_collection(@grouped_by_category.values.first(4))
  end
end
