class CartsController < ApplicationController
  layout 'main'

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  
  def show
    @order_items = @cart.order_items.order(:created_at)
    @cart = @cart.decorate
    @order_items = OrderItemDecorator.decorate_collection(@order_items)
  end

  def update
    coupon = Coupon.where(code: cart_params[:coupon_code]).first
    respond_to do |format|
      if coupon
        @cart.update(coupon_code: coupon.code, coupon_price: coupon.discount)
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  def destroy
  end

  private

  def invalid_cart
    logger.error t(:no_cart)
    redirect_to home_index_url, notice: t(:no_cart)
  end

  def cart_params
    params.require(:cart).permit(:coupon_code)
  end
end
