# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books_authors, dependent: :destroy, validate: false
  has_many :books, through: :books_authors, validate: false
  before_destroy :ensure_not_referenced_by_any_book

  validates :first_name, :last_name, presence: true
  validates :first_name, uniqueness: { scope: :last_name }
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :first_name, :last_name, format: { with: NAME }

  private
  def ensure_not_referenced_by_any_book
    unless books.empty?
      errors.add(:base, 'There are books')
      throw :abort
    end
  end
end
