class NewOrderItemService
  class << self
    def call(book:, quantity: 1, cart:)
      current_item = cart.order_items.find_by(book_id: book.id)
      if current_item
        current_item = change_quantity(current_item, quantity)
      else
        current_item = cart.order_items.new(book_id: book.id, book_name: book.title,
                                            book_price: book.price, total: book.price, 
                                            quantity: quantity)
        current_item.image.attach(book.images.first.photo.blob) if book.images.present?
      end
      current_item.save
    end

    private

    def change_quantity(current_item, quantity)
      current_item.quantity += quantity.to_i
      current_item.total = current_item.book_price * current_item.quantity
      current_item
    end
  end
end
