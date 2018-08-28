class CartsController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  
  def show
    @order_items = @cart.order_items
    @total_price = @cart.total_price
  end

  def update
  end

  def destroy
  end

  private

  def invalid_cart
    logger.error t(:no_cart)
    redirect_to home_index_url, notice: t(:no_cart)
  end
end
