# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource except: %i[login signup forgot_password change_password]

  before_action :authenticate_user!, except: %i[login signup forgot_password change_password]
  before_action :set_user

  respond_to :js, only: %i[update update_password]

  def edit
    build_addresses
    @billing_form = AssignAddressFormService.new(@user, :billing_address).call
    @shipping_form = AssignAddressFormService.new(@user, :shipping_address).call
    @password_form = PasswordForm.new(user_id: @user.id)
  end

  def update
    return respond_with @user if @user.update_without_password(user_params)
    render :edit
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

  def build_addresses
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
  end
end
