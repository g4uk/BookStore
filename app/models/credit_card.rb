class CreditCard < ApplicationRecord
  belongs_to :order

  attr_accessor :cvv

  validates :number, :owner_name, :expiration_date, presence: true
  validates :owner_name, length: { maximum: 50 }
  validates :cvv, length: { minimum: 3, maximum: 4 }
  validates :number, format: { with: CREDIT_CARD_NUMBER }
  validates :owner_name, format: { with: NAME }
  validates :expiration_date, format: { with: EXPIRATION_DATE }
end
