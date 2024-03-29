# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :first_name, :last_name, :address, :country, :city, :zip, :phone, presence: true
  validates :first_name, :last_name, :address, :country, :city, length: { maximum: 50 }
  validates :zip, length: { maximum: 10 }
  validates :phone, length: { maximum: 15 }
  validates :first_name, :last_name, :country, :city, format: { with: NAME }
  validates :address, format: { with: ADDRESS }
  validates :zip, format: { with: ZIP }
  validates :phone, format: { with: PHONE }
end
