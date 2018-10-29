# frozen_string_literal: true
class CommentForm
  include ActiveModel::Model
  include Virtus.model

  COMMENT = %r/\A[a-zA-Z0-9\s\.!,;#$%&'*+\/=?^_`{\(|\)}~-]+{1,500}\Z/
  COMMENT_INPUT = '^[a-zA-Z0-9\s\.!,;#$%&\'*+\/=?^_`{\(|\)}~-]{1,500}$'

  attr_accessor :book_id, :user_id, :text, :title, :rating

  validates :title, :text, presence: true
  validates :title, :text, format: { with: COMMENT }
  validates :title, length: { maximum: 80 }
  validates :text, length: { maximum: 500 }

  def save
    return false unless valid?
    Comment.create(book_id: book_id, user_id: user_id, title: title, text: text, rating: valid_rating)
  end

  private

  def valid_rating
    rating = 0 if rating.nil?
  end
end
