# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      super
    else
      redirect_to login_users_path, flash: { danger: I18n.t(:invalid_login) }
    end
  end

  protected

  def after_sign_in_path_for(_resource)
    books_path
  end
end
