# frozen_string_literal: true

class NewOrderItemService < Rectify::Command
  DEFAULT_QUANTITY = 1

  def initialize(book_id:, quantity: DEFAULT_QUANTITY, cart:)
    @book = Book.find(book_id)
    @quantity = quantity
    @cart = cart
    @current_item = cart.order_items.find_by(book_id: book_id)
  end

  def call
    if @current_item
      calculate_quantity
    else
      create_item
    end
    return broadcast(:ok) if @current_item.save
    broadcast(:invalid)
  end

  private

  def create_item
    @current_item = @cart.order_items.new(book_id: @book.id, book_name: @book.title,
                                          book_price: @book.price, total: @book.price,
                                          quantity: @quantity)
    @current_item.image.attach(@book.images.first.photo.blob) if @book.images.present?
  end

  def calculate_quantity
    @current_item.quantity += @quantity.to_i
    @current_item.total = @current_item.book_price * @current_item.quantity
  end
end
