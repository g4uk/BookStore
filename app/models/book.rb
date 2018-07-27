# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category
  has_many :books_authors, dependent: :destroy
  has_many :authors, through: :books_authors

  validates_numericality_of :price
  validates_presence_of :category, :title, :price
end
