# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :book, counter_cache: true
  belongs_to :user

  enum status: { unprocessed: 0, approved: 1, rejected: 2 }

  scope :approved, -> { includes(:user).where(status: 'approved').order(:created_at) }
end
