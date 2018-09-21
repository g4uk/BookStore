class Cart < ApplicationRecord
  has_many :order_items, as: :itemable, dependent: :destroy
end
