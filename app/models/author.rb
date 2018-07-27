# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books_authors, dependent: :destroy
  has_many :books, through: :books_authors

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, scope: :last_name
end
