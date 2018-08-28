class UsersController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :authenticate_user!, except: %i[login_customer signup_customer]
  before_action :set_cart, :set_user
  before_action :set_addresses, only: %i[update_billing_address update_shipping_address edit]

  def edit; end

  def update
    respond_to do |format|
      if @user.update_without_password(user_params)
        format.js
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def update_billing_address
    respond_to do |format|
      if @user.billing_address.update(user_params[:billing_address_attributes])
        format.js { render :update_addresses }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :edit_addresses }
      end
    end
  end

  def update_shipping_address
    respond_to do |format|
      if @user.shipping_address.update(user_params[:shipping_address_attributes])
        format.js { render :update_addresses }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :edit_addresses }
      end
    end
  end

  def update_password
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      format.js { render :update_password }
    else
      format.json { render json: @user.errors, status: :unprocessable_entity }
      format.js { render :edit_password }
    end
  end

  def login_customer; end

  def signup_customer; end

  private

  def set_addresses
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
  end

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email, 
                                 :current_password,
                                 billing_address_attributes:
                                   %i[first_name last_name address city zip country phone],
                                 shipping_address_attributes:
                                   %i[first_name last_name address city zip country phone])
  end
end
