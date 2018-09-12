class OrderItemsController < ApplicationController
  def create
    if params[:book_id].nil?
      book = Book.find(order_item_params[:book_id])
      @order_item = @cart.add_book(book: book, quantity: order_item_params[:quantity])
    else
      book = Book.find(params[:book_id])
      @order_item = @cart.add_book(book: book)
    end
    respond_to do |format|
      if @order_item.save
        format.js
      else
        format.html { redirect_to @order_item.cart }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def order_item_params
    params.require(:order_item).permit(:book_id, :quantity)
  end
end
