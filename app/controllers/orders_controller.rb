class OrdersController < ApplicationController
  layout 'main'
  before_action :checkout_authentication, only: :create
  before_action :authenticate_user!, except: :create
  before_action :set_order, :ensure_cart_isnt_empty, only: [:create]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @user = current_user
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    redirect_to checkout_confirm_path if @order.may_confirm?
    redirect_to checkout_delivery_path if @order.may_fill_delivery?
    redirect_to checkout_payment_path if @order.may_fill_payment?
    @cart = @cart.decorate
    @order = FillOrderWithItemsService.call(cart: @cart, order: @order, user: current_user)
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

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

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

  def set_order
    @order = Order.where('status < 5 AND user_id = ? ', current_user.id).last
    return @order = Order.new if @order.nil?
    @order
  end
end
