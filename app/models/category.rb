# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :books, dependent: :destroy
  before_destroy :ensure_not_referenced_by_any_book

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 80 }
  validates :name, format: { with: CATEGORY }

  private
  def ensure_not_referenced_by_any_book
    unless books.empty?
      errors.add(:base, 'There are books')
      throw :abort
    end
  end
end
