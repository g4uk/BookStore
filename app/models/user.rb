class User < ApplicationRecord
  include UsersSettings
  rolify

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
         :validatable, :omniauthable, omniauth_providers: %i[facebook]

  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy

  validates :password, password: true
end
