# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books_authors, dependent: :destroy
  has_many :books, through: :books_authors

  validates :first_name, :last_name, presence: true
  validates :first_name, uniqueness: { scope: :last_name }
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :first_name, :last_name, format: { with: NAME }
end
