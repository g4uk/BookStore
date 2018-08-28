# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:valid_code) { '8908ADRE' }
  let(:invalid_code) { '89%^%$%^#' }

  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:status) }
    it { should belong_to(:delivery) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:billing_address).dependent(:destroy) }
    it { should have_one(:credit_card).dependent(:destroy) }
  end
  context 'validations' do
    it { should validate_numericality_of(:total).is_greater_than_or_equal_to (0.01)}
    it { should allow_value(valid_code).for(:coupon_code) }
    it { should_not allow_value(invalid_code).for(:coupon_code) }
    it { should validate_length_of(:coupon_code).is_at_most(10) }
  end
  context 'attributes' do
    it { should have_db_column(:status).of_type(:integer) }
    it { should have_db_column(:delivery_type).of_type(:string) }
    it { should have_db_column(:total).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { should have_db_column(:delivery_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { should have_db_column(:delivery_duration).of_type(:string) }
    it { should have_db_column(:coupon_code).of_type(:string) }
  end
end
