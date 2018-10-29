# frozen_string_literal: true

class PasswordForm
  include ActiveModel::Model
  include Virtus.model

  PASSWORD_INPUT = '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})'

  attr_accessor :current_password, :password, :password_confirmation, :user_id

  validates :password, password: true
  validates :current_password, :password, :password_confirmation, presence: true

  def save
    return false unless valid?
    update_password
  end

  private

  def update_password
    user = User.find(user_id)
    user.update_with_password(current_password: current_password,
                              password: password,
                              password_confirmation: password_confirmation)
    user
  end
end
