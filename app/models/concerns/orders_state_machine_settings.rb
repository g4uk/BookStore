# frozen_string_literal: true

module OrdersStateMachineSettings
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: 'status' do
      state :created, initial: true
      state :address
      state :shipping
      state :payment
      state :confirmed
      state :in_progress
      state :in_queue
      state :in_delivery
      state :delivered
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
end
