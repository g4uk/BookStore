# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 80 }
  validates :name, format: { with: CATEGORY }
end
