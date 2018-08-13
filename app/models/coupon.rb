class Coupon < ApplicationRecord
  validates :code, presence: true
  validates :code, format: { with: COUPON }
  validates :code, length: { maximum: 10 }
  validates :discount, numericality: true
end
