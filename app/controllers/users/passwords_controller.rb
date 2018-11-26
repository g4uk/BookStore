# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def create
    super do |resource|
      unless successfully_sent?(resource)
        return redirect_to forgot_password_users_path, flash: { danger: resource.errors.full_messages }
      end
    end
  end

  def update
    super do |resource|
      unless resource.errors.empty?
        return redirect_to change_password_users_path(reset_password_token: resource.reset_password_token), flash: { danger: resource.errors.full_messages }
      end
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? root_path : login_users_path
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    login_users_path
  end
end
