class OrderItemsController < ApplicationController

  before_action :set_item, only: [:decrement, :increment, :destroy]

  def create
    if params[:book_id].nil?
      book = Book.find(order_item_params[:book_id])
    else
      book = Book.find(params[:book_id])
    end
    quantity = params[:order_item] ? order_item_params[:quantity] : 1
    @order_item = NewOrderItemService.call(book: book, quantity: quantity,
                                           order_items: @cart.order_items)
    @cart = @cart.decorate
    respond_to do |format|
      if @order_item.save
        format.js
      else
        format.html { redirect_to @order_item.cart }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
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
    @order_items = @cart.order_items.order(:created_at)
    @order_items = OrderItemDecorator.decorate_collection(@order_items)
    @total_price = @cart.total_price
  end

  def order_item_params
    params.require(:order_item).permit(:book_id, :quantity)
  end
end
