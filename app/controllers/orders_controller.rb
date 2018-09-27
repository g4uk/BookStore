class OrdersController < ApplicationController
  layout 'main'

  load_and_authorize_resource except: :create

  before_action :authenticate_user!, except: :create
  before_action :checkout_authentication, :set_order, :ensure_cart_isnt_empty, only: [:create]
  before_action :decorate_cart

  # GET /orders
  # GET /orders.json
  def index
    @scopes = OrdersScopesService.call(current_user)
    @scope = params[:scope] ? params[:scope].to_sym : :all
    @orders = @scopes[@scope].decorate
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    decorate_objects
    @user = current_user
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = CopyInfoToOrderService.new(cart: @cart, order: @order, user: current_user).call
    if @order.save
      @order.checkout! if @order.may_checkout?
      session[:order_id] = @order.id
      redirect_to checkouts_path
    else
      flash[:notice] = @order.errors.messages
      redirect_back(fallback_location: cart_path(@cart))
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def decorate_objects
    @order = Order.includes(order_items: [:book, image_attachment: :blob]).find(params[:id]).decorate
    @countries_with_codes = CountriesListService.call
    @deliveries = Delivery.all.decorate
    @order_items = @order.order_items
    @billing_address = AddressDecorator.decorate(@order.billing_address)
    @shipping_address = AddressDecorator.decorate(@order.shipping_address)
  end

  def order_params
    params.require(:order).permit(:user_id, :delivery_id, :credit_card_id, :coupon_id, :status)
  end

  def ensure_cart_isnt_empty
    redirect_to root_url, notice: 'Your cart is empty' if @cart.order_items.empty?
  end

  def checkout_authentication
    unless user_signed_in?
      flash[:notice] = 'You need to sign in or sign up before continuing.'
      redirect_to checkout_login_users_url
    end
  end

  def decorate_cart
    @cart = @cart.decorate
  end

  def set_order
    @order = Order.where('status < 5 AND user_id = ? ', current_user.id).last
    return @order = Order.new if @order.nil?
    @order
  end
end
