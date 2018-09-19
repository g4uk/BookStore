class Comment < ApplicationRecord
  belongs_to :book
  belongs_to :user

  enum status: { unprocessed: 0, approved: 1, rejected: 2 }

  scope :approved, -> { where(status: 'approved') }

  validates :title, :text, presence: true
  validates :title, :text, format: { with: COMMENT }
  validates :title, length: { maximum: 80 }
  validates :text, length: { maximum: 500 }
end
