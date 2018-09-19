class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
         :validatable, :omniauthable, omniauth_providers: %i[facebook]

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
    add_role(:customer) if roles.blank?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (email = conditions.delete(:email)).present?
      where(email: email.downcase).first
    elsif conditions.key?(:reset_password_token)
      where(reset_password_token: conditions[:reset_password_token]).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token.first(8) + rand(10).to_s
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end
end
