class BooksAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  validates_presence_of :book, :author
end
