# frozen_string_literal: true

class QuickSignupsController < ApplicationController

  def new; end

  def create
    QuickRegistrationService.call(user_params) do
      on(:ok) do |user|
        sign_in(:user, user)
        redirect_to cart_path(session[:cart_id]), notice: t('notice.signed_up')
      end
      on(:invalid) do |errors|
        redirect_to new_quick_signup_path, flash: { danger: errors }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
