class NewOrderItemService
  class << self
    def call(book:, quantity: 1, order_items:)
      current_item = order_items.find_by(book_id: book.id)
      if current_item
        current_item.quantity += quantity.to_i
        current_item.total = current_item.book_price * current_item.quantity
      else
        current_item = order_items.build(book_id: book.id, book_name: book.title,
                                        book_price: book.price, total: book.price, quantity: quantity)
        current_item.image.attach(book.images.first.blob) unless book.images.blank?
      end
      current_item
    end
  end
end