class OrderItemsController < ApplicationController
  include CurrentCart
  
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: %i[update destroy]

  def create
    book = Book.find(params[:book_id])
    @order_item = @cart.add_book(book)
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
    params.require(:order_item).permit(:book_id)
  end
end
