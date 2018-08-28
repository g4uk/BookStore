class SettingsController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart, :set_user

  def index
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
  end

  def update
    @user.build_billing_address if @user.billing_address.blank?
    @user.build_shipping_address if @user.shipping_address.blank?
    respond_to do |format|
      if @user.billing_address.update(user_params[:billing_address_attributes])
        format.html { redirect_to settings_path, notice: 'Order was successfully updated.' }
      else
        format.html { render :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(billing_address_attributes:
                                   %i[first_name last_name address city zip country phone],
                                 shipping_address_attributes:
                                   %i[first_name last_name address city zip country phone])
  end
end
