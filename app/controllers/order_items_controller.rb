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
    recalculate
    respond_to do |format|
      format.js
    end
  end

  def decrement
    @order_item.decrement(:quantity)
    recalculate
    @order_item.total = @order_item.total_price
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  def increment
    @order_item.increment(:quantity)
    recalculate
    @order_item.total = @order_item.total_price
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  private

  def set_item
    @order_item = OrderItem.find(params[:id])
    @order_item = @order_item.decorate
    @cart = @cart.decorate
  end

  def recalculate
    @order_items = OrderItemDecorator.decorate_collection(@cart.order_items.order(:created_at))
    @total_price = @cart.total_price
  end

  def order_item_params
    params.require(:order_item).permit(:book_id, :quantity)
  end

  def check_params
    @book_id = params[:book_id] ? params[:book_id] : order_item_params[:book_id]
    @quantity = params[:order_item] ? order_item_params[:quantity] : 1
  end
end
