# frozen_string_literal: true

class Cart < ApplicationRecord
  include CartCalculations

  has_many :order_items, as: :itemable, dependent: :destroy

  scope :weeks_old, -> { where(['created_at < ?', Time.now.midnight - 7.days]) }
end
