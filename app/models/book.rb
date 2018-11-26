# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category, counter_cache: true
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
  validates :images, image_number: true

  accepts_nested_attributes_for :images, update_only: true

  scope :newest, -> { order('created_at desc') }
end
