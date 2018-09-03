class PopularBooksService
  class << self
    def call
      grouped_order_items = OrderItem.all.group(:book_id).count
      sorted_order_items = grouped_order_items.sort_by { |_key, value| value }.reverse.to_h
      books_ids = sorted_order_items.keys.first(4)
      BookDecorator.decorate_collection(Book.where(id: books_ids))
    end
  end
end
