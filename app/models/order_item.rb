# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :itemable, polymorphic: true

  belongs_to :book, optional: true
  has_one_attached :image, dependent: :destroy

  validates :book_price, :book_name, :total, presence: true
  validates :book_price, :total, numericality: { greater_than_or_equal_to: 0.01 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
