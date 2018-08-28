class OrderItem < ApplicationRecord
  belongs_to :book, optional: true
  belongs_to :cart
  belongs_to :order, optional: true
  has_one_attached :image, dependent: :destroy

  validates :book_price, :book_name, :total, presence: true
  validates :book_price, :total, numericality: { greater_than_or_equal_to: 0.01 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    book_price * quantity
  end
end
