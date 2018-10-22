class OrdersController < ApplicationController
  ORDERS_SCOPES = %i[sorted_paid in_progress in_delivery delivered canceled].freeze

  load_and_authorize_resource except: :create

  before_action :authenticate_user!, except: :create

  before_action :checkout_authentication, only: :create

  def index
    @scopes = ORDERS_SCOPES
    @scope = params[:scope] ? params[:scope].to_sym : :sorted_paid
    @orders = current_user.orders.send(@scope).decorate
  end

  def show
    @order = Order.includes(order_items: [:book, image_attachment: :blob]).find(params[:id]).decorate
    @order_presenter = OrderPresenter.new(@order)
    @user = current_user
  end

  def create
    @order = current_user.orders.not_paid.last || Order.new
    created_order = CreateOrderService.new(cart: @cart, user: current_user, order: @order).call
    if created_order
      session[:order_id] = @order.id
      redirect_to checkouts_path
    else
      redirect_back(fallback_location: cart_path(@cart), notice: created_order.errors.full_messages)
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :delivery_id, :credit_card_id, :coupon_id, :status)
  end

  def checkout_authentication
    redirect_to checkout_login_users_path, notice: t('notice.login') unless user_signed_in?
  end
end
