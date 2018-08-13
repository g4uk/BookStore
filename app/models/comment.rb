class Comment < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :title, :text, presence: true
  validates :title, :text, format: { with: COMMENT }
  validates :title, length: { maximum: 80 }
  validates :text, length: { maximum: 500 }
  validates :status, inclusion: { in: [true, false] }
end
