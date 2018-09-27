class UsersController < ApplicationController
  layout 'main'

  load_and_authorize_resource except: %i[login signup forgot_password change_password 
                                         checkout_login quick_signup]

  before_action :authenticate_user!, except: %i[login signup forgot_password change_password 
                                                checkout_login quick_signup]
  before_action :set_user, :decorate_cart
  before_action :set_addresses, :set_countries, only: %i[update_billing_address update_shipping_address edit]

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
    respond_to do |format|
      if @user.update_with_password(user_params)
        bypass_sign_in(@user)
        format.js { render :update_password }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render :edit_password }
      end
    end
  end

  def login; end

  def signup; end

  def forgot_password; end

  def checkout_login; end

  def quick_signup
    generated_password = GeneratePasswordService.call
    user = User.create(email: user_params[:email], password: generated_password)
    if user.errors.empty?
      sign_in(:user, user)
      ApplicationMailer.welcome_email(user, generated_password).deliver
      redirect_to @cart
    else
      flash[:danger] = flash[:danger].to_a.concat user.errors.full_messages
      redirect_to checkout_login_users_path
    end
  end

  def change_password
    @resource = User.new
    @minimum_password_length = @resource.class.password_length.min
    @resource.reset_password_token = params[:reset_password_token]
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def decorate_cart
    @cart = @cart.decorate
  end

  def set_addresses
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
  end

  def set_countries
    @countries_with_codes = CountriesListService.call
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
