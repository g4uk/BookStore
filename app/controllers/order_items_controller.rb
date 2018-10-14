class OrderItemsController < ApplicationController
  DEFAULT_QUANTITY = 1

  before_action :set_item, except: :create

  def create
    @item_presenter = OrderItemPresenter.new(presenter_params)
    book = Book.find(@item_presenter.book_id)
    respond_to do |format|
      if NewOrderItemService.new(book: book, quantity: @item_presenter.quantity, cart: @cart).call
        format.js
      else
        redirect_back(fallback_location: cart_path(@cart), flash: { danger: t('danger.not_saved')})
      end
    end
  end

  def destroy
    @order_item.destroy
    decorate_items
    respond_to do |format|
      format.js
    end
  end

  def decrement
    @order_item.decrement(:quantity)
    recalculate_total
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  def increment
    @order_item.increment(:quantity)
    recalculate_total
    respond_to do |format|
      format.js if @order_item.save
    end
  end

  private

  def set_item
    @order_item = OrderItem.find(params[:id]).decorate
  end

  def recalculate_total
    @order_item.total = CartUtilsService.item_total_price(@order_item)
    decorate_items
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
