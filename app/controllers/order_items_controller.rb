class OrderItemsController < ApplicationController

  before_action :set_item, only: %i[decrement increment destroy]

  def create
    check_params
    NewOrderItemService.call(book: Book.find(@book_id), quantity: @quantity, cart: @cart)
    @cart = @cart.decorate
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @order_item.destroy
    @order_items = OrderItemDecorator.decorate_collection(@cart.order_items.includes(image_attachment: :blob).order(:created_at))
    @cart = @cart.decorate
    respond_to do |format|
      format.js
    end
  end

  def decrement
    @order_item.decrement(:quantity)
    recalculate
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  def increment
    @order_item.increment(:quantity)
    recalculate
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  private

  def set_item
    @order_item = OrderItem.find(params[:id]).decorate
  end

  def recalculate
    @order_item.total = CartUtilsService.item_total_price(@order_item)
    @order_items = OrderItemDecorator.decorate_collection(@cart.order_items.includes(image_attachment: :blob).order(:created_at))
    @cart = @cart.decorate
  end

  def order_item_params
    params.require(:order_item).permit(:book_id, :quantity)
  end

  def check_params
    @book_id = params[:book_id] ? params[:book_id] : order_item_params[:book_id]
    @quantity = params[:order_item] ? order_item_params[:quantity] : 1
  end
end
