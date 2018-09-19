# frozen_string_literal: true

class Book < ApplicationRecord
  serialize :dimensions, Hash

  belongs_to :category
  has_many :books_authors, dependent: :destroy
  has_many :authors, through: :books_authors
  has_many :comments, dependent: :destroy
  has_many :order_items, dependent: :nullify
  has_many :images, dependent: :destroy

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, :price, presence: true
  validates :title, uniqueness: true
  validates :title, :materials, length: { maximum: 255 }
  validates :publishing_year, inclusion: { in: 1902..Date.today.year }
  validate :validate_images

  accepts_nested_attributes_for :images, update_only: true

  def validate_images
    errors.add(:images, 'Too much images. Only 4 allowed') if images.size > 4
  end
end
