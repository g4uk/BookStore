class CreditCard < ApplicationRecord
  belongs_to :order

  attr_accessor :owner_name, :expiration_date, :cvv

  validates :number, presence: true
  validates :number, format: { with: CREDIT_CARD_NUMBER }
end
