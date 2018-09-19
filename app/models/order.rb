class Order < ApplicationRecord
  include AASM

  attr_accessor :billing_flag

  belongs_to :user
  belongs_to :delivery, optional: true

  enum status: { created: 0, address: 1, shipping: 2, in_progress: 3,
                 payment: 4, in_queue: 5, in_delivery: 6, delivered: 7, canceled: 8 }

  has_many :order_items, dependent: :destroy
  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy, required: false
  has_one :credit_card, dependent: :destroy

  accepts_nested_attributes_for :shipping_address, update_only: true
  accepts_nested_attributes_for :billing_address, update_only: true
  accepts_nested_attributes_for :credit_card, update_only: true

  validates :total, numericality: { greater_than_or_equal_to: 0 }

  aasm column: 'status' do
    state :created, initial: true
    state :address
    state :shipping
    state :payment
    state :confirmed
    state :in_progress
    state :in_queue
    state :in_delivery
    state :canceled

    event :checkout do
      transitions from: :created, to: :address
    end
    event :fill_address do
      transitions from: :address, to: :shipping
    end
    event :fill_delivery do
      transitions from: :shipping, to: :in_progress
    end
    event :fill_payment do
      transitions from: :in_progress, to: :payment
    end
    event :confirm do
      transitions from: :payment, to: :in_queue
    end
    event :process do
      transitions from: :in_queue, to: :in_delivery
    end
    event :ship do
      transitions from: :in_delivery, to: :delivered
    end
    event :cancel do
      transitions from: %i[in_progress in_queue in_delivery delivered], to: :canceled
    end
  end
end
