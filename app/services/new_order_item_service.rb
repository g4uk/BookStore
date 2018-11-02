class NewOrderItemService < Rectify::Command
  DEFAULT_QUANTITY = 1

  def initialize(book:, quantity: DEFAULT_QUANTITY, cart:)
    @book = book
    @quantity = quantity
    @cart = cart
    @current_item = cart.order_items.find_by(book_id: book.id)
  end

  def call
    calculate_quantity
    create_item
    return broadcast(:ok) if @current_item.save
    broadcast(:invalid)
  end

  private

  def create_item
    unless @current_item
      @current_item = @cart.order_items.new(book_id: @book.id, book_name: @book.title,
                                            book_price: @book.price, total: @book.price, 
                                            quantity: @quantity)
      @current_item.image.attach(@book.images.first.photo.blob) if @book.images.present?
    end
  end

  def calculate_quantity
    if @current_item
      @current_item.quantity += @quantity.to_i
      @current_item.total = @current_item.book_price * @current_item.quantity
    end
  end
end
