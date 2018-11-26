# frozen_string_literal: true

class CartsController < ApplicationController
  respond_to :js, only: :update

  def show
    decorate_order_items
  end

  def update
    decorate_order_items
    ApplyCouponService.call(code: cart_params[:coupon_code], cart: @cart) do
      on(:ok) { render :update }
      on(:invalid) { render :edit }
    end
  end

  private

  def cart_params
    params.require(:cart).permit(:coupon_code)
  end

  def decorate_order_items
    @order_items = @cart.order_items.includes(image_attachment: :blob).order(:created_at).decorate
  end
end
