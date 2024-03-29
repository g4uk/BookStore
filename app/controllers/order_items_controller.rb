# frozen_string_literal: true

class OrderItemsController < ApplicationController
  respond_to :js

  DEFAULT_QUANTITY = 1

  before_action :set_item, except: :create

  def create
    @item_presenter = OrderItemPresenter.new(presenter_params)
    NewOrderItemService.call(book_id: @item_presenter.book_id, quantity: @item_presenter.quantity, cart: @cart) do
      on(:ok) { respond_with @item_presenter }
      on(:invalid) do
        redirect_back(fallback_location: cart_path(session[:cart_id]), flash: { danger: t('danger.not_saved') })
      end
    end
  end

  def destroy
    @order_item.destroy
    decorate_items
    respond_with @order_item
  end

  def decrement
    @order_item.decrement(:quantity)
    OrderItemUpdateService.call(@order_item) do
      on(:ok) do |item|
        decorate_items
        respond_with item
      end
    end
  end

  def increment
    @order_item.increment(:quantity)
    OrderItemUpdateService.call(@order_item) do
      on(:ok) do |item|
        decorate_items
        respond_with item
      end
    end
  end

  private

  def set_item
    @order_item = OrderItem.find(params[:id]).decorate
  end

  def decorate_items
    @order_items = @cart.order_items.includes(image_attachment: :blob).order(:created_at).decorate
  end

  def order_item_params
    params.require(:order_item).permit(:book_id, :quantity)
  end

  def presenter_params
    { book_id: params[:book_id], item_params: params[:order_item] }
  end
end
