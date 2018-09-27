class CartsController < ApplicationController
  layout 'main'

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  before_action :decorate_cart

  def show;end

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

  private

  def invalid_cart
    logger.error t(:no_cart)
    redirect_to home_index_url, notice: t(:no_cart)
  end

  def cart_params
    params.require(:cart).permit(:coupon_code)
  end

  def decorate_cart
    @order_items = OrderItemDecorator.decorate_collection(@cart.order_items.includes(image_attachment: :blob).order(:created_at))
    @cart = @cart.decorate
  end
end
