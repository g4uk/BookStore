# frozen_string_literal: true

class Delivery < ApplicationRecord
  has_many :orders, dependent: :nullify

  validates :name, :duration, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :name, :duration, length: { maximum: 80 }
end
