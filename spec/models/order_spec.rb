# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryBot.create :order }
  let(:valid_code) { '8908ADRE' }
  let(:invalid_code) { '89%^%$%^#' }

  it { expect(order).to belong_to(:user) }
  it { expect(order).to belong_to(:status) }
  it { expect(order).to belong_to(:delivery) }
  it { expect(order).to have_many(:order_items).dependent(:destroy) }
  it { expect(order).to have_one(:billing_address).dependent(:destroy) }
  it { expect(order).to have_one(:credit_card).dependent(:destroy) }
  it { expect(order).to validate_numericality_of(:total) }
  it { expect(order).to allow_values(0, 80.80).for(:total) }
  it { expect(order).not_to allow_value(-1).for(:total) }
  it { expect(order).to allow_value(valid_code).for(:coupon_code) }
  it { expect(order).not_to allow_value(invalid_code).for(:coupon_code) }
end
