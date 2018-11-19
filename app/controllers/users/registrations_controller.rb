# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      unless resource.persisted?
        return redirect_to signup_users_path, flash: { danger: resource.errors.full_messages }
      end
    end
  end

  protected

  def after_sign_up_path_for(_resource)
    books_path
  end
end
