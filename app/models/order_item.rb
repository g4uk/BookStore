class OrderItem < ApplicationRecord
  belongs_to :book
  belongs_to :cart
  belongs_to :order

  validates :book_price, :book_name, :quantity, presence: true
  validates :book_price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :quantity, numericality: true
end
