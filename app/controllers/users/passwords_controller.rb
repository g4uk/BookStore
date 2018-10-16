# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      super
    else
      redirect_to forgot_password_users_path, flash: { danger: resource.errors.full_messages }
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      redirect_to change_password_users_path(reset_password_token: resource.reset_password_token), flash: { danger: resource.errors.full_messages }
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : login_users_path(resource_name)
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    login_users_path if is_navigational_format?
  end
end
