class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :addresses, dependent: :destroy

  validate :password_complexity

  def password_complexity
    return if password.blank? || password =~ PASSWORD_REGEXP
    errors.add :password, PASSWORD_ERROR
  end
end
