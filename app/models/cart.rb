class Cart < ApplicationRecord
  has_many :order_items, dependent: :nullify

  def add_book(book:, quantity: 1)
    current_item = order_items.find_by(book_id: book.id)
    if current_item
      current_item.quantity += quantity.to_i
      current_item.total = current_item.total_price
    else
      current_item = order_items.build(book_id: book.id, book_name: book.title,
                                       book_price: book.price, total: book.price, quantity: quantity)
      current_item.image.attach(book.images.first.blob)
    end
    current_item
  end

  def total_price
    order_items.to_a.sum(&:total)
  end

  def total_quantity
    order_items.to_a.sum(&:quantity)
  end
end
