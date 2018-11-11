# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      super
    else
      flash[:danger] = I18n.t(:invalid_login)
      redirect_to login_users_url
    end
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  def after_sign_in_path_for(_resource)
    books_path
  end
end
