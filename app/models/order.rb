class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :delivery, optional: true

  enum status: { created: 0, address: 1, shipping: 2, payment: 3,
                 confirmed: 4, in_queue: 5, in_progress: 6,
                 in_delivery: 7, delivered: 8, canceled: 9 }

  has_many :order_items, dependent: :destroy

  has_one :billing_address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :billing_address, update_only: true

  has_one :shipping_address, as: :addressable, dependent: :destroy, required: false
  accepts_nested_attributes_for :shipping_address, update_only: true

  has_one :credit_card, dependent: :destroy
  accepts_nested_attributes_for :credit_card, update_only: true

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :coupon_code, length: { maximum: 10 }, allow_blank: true
  validates :coupon_code, format: { with: COUPON }, allow_blank: true
  validates :coupon_price, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      #item.cart_id = nil
      order_items << item
    end
  end

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
      transitions from: :shipping, to: :payment
    end
    event :fill_payment do
      transitions from: :payment, to: :confirmed
    end
    event :confirm do
      transitions from: :confirmed, to: :in_queue
    end
    event :edit_address do
      transitions from: :address, to: :confirmed, guard: :delivery_checked?
    end
    event :edit_delivery do
      transitions from: :shipping, to: :confirmed, guard: :payment_exists?
    end
    event :progress do
      transitions from: :in_queue, to: :in_progress
    end
    event :process do
      transitions from: :in_progress, to: :in_delivery
    end
    event :ship do
      transitions from: :in_delivery, to: :delivered
    end
    event :cancel do
      transitions from: %i[in_queue in_delivery in_progress], to: :canceled
    end

    def delivery_checked?
      !delivery_type.blank?
    end

    def payment_exists?
      !credit_card.blank?
    end
  end
end
