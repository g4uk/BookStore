# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource except: %i[login signup forgot_password change_password
                                         checkout_login quick_signup]

  before_action :authenticate_user!, except: %i[login signup forgot_password change_password
                                                checkout_login quick_signup]
  before_action :set_user
  before_action :set_addresses, only: %i[update_billing_address update_shipping_address edit]

  respond_to :js, only: %i[update update_address update_password]

  def edit
    @billing_form = AssignAddressFormService.new(@user, :billing_address).call
    @shipping_form = AssignAddressFormService.new(@user, :shipping_address).call
    @password_form = PasswordForm.new(user_id: @user.id)
  end

  def update
    return respond_with @user if @user.update_without_password(user_params)
    render :edit
  end

  def update_address
    instance_variable_set("@#{address_form_params[:type]}_form".to_sym, AddressForm.new(address_form_params))
    @updated_address = instance_variable_get("@#{address_form_params[:type]}_form")
    return render :update_addresses if @updated_address.save
    render :edit_addresses
  end

  def update_password
    @password_form = PasswordForm.new(password_params)
    @user = @password_form.save
    return render :edit_password unless @user
    bypass_sign_in(@user)
    respond_with @user
  end

  def login; end

  def signup; end

  def forgot_password; end

  def checkout_login; end

  def quick_signup
    QuickRegistrationService.call(user_params) do
      on(:ok) do |user|
        sign_in(:user, user)
        redirect_to cart_path(session[:cart_id]), notice: t('notice.signed_up')
      end
      on(:invalid) do |errors|
        redirect_to checkout_login_users_path, flash: { danger: errors }
      end
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
      format.html { redirect_to root_url, notice: t('notice.destroyed') }
    end
  end

  private

  def set_addresses
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
  end

  def set_user
    @user = current_user
  end

  def password_params
    params.require(:password_form).permit(:password, :password_confirmation, :current_password, :user_id)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email,
                                 :current_password,
                                 billing_address_attributes:
                                   %i[first_name last_name address city zip country phone],
                                 shipping_address_attributes:
                                   %i[first_name last_name address city zip country phone])
  end

  def address_form_params
    params.require(:address_form).permit(%i[first_name last_name address city zip country phone type addressable_id])
  end
end
