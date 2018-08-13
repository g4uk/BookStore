class Order < ApplicationRecord
  belongs_to :user
  belongs_to :status
  belongs_to :delivery
  has_many :order_items, dependent: :destroy
  has_one :billing_address, dependent: :destroy
  has_one :shipping_address, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :coupon_code, length: { maximum: 10 }
  validates :coupon_code, format: { with: COUPON }
end
