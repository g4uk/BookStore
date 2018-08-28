class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :billing_address, update_only: true
  accepts_nested_attributes_for :shipping_address,
                                reject_if: :all_blank

  validate :password_complexity

  after_create :assign_default_role

  def password_complexity
    return if password.blank? || password =~ PASSWORD_REGEXP
    errors.add :password, PASSWORD_ERROR
  end

  def assign_default_role
    self.add_role(:customer) if self.roles.blank?
  end
end
