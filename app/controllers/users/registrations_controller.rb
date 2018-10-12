# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        super
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to signup_users_path, flash: { danger: resource.errors.full_messages }
    end
  end

  protected

  def after_sign_up_path_for(resource)
    books_path
  end
end
