class CartsController < ApplicationController
  def show
    decorate_order_items
  end

  def update
    decorate_order_items
    @coupon = Coupon.find_by(code: cart_params[:coupon_code])
    respond_to do |format|
      if @coupon
        @cart.update(coupon_code: @coupon.code, coupon_price: @coupon.discount)
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  private

  def cart_params
    params.require(:cart).permit(:coupon_code)
  end

  def decorate_order_items
    @order_items = @cart.order_items.includes(image_attachment: :blob).order(:created_at).decorate
    @cart = @cart.decorate
  end
end
