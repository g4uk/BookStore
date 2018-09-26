# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:statuses) { { created: 0, address: 1, shipping: 2, in_progress: 3,
                     payment: 4, in_queue: 5, in_delivery: 6, delivered: 7, canceled: 8 } }

  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:delivery) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:billing_address).dependent(:destroy) }
    it { should have_one(:shipping_address).dependent(:destroy) }
    it { should have_one(:credit_card).dependent(:destroy) }
    it { should define_enum_for(:status).with(statuses) }
    it { should accept_nested_attributes_for(:billing_address).update_only(true) }
    it { should accept_nested_attributes_for(:shipping_address).update_only(true) }
    it { should accept_nested_attributes_for(:credit_card).update_only(true) }
  end
  context 'validations' do
    it { should validate_numericality_of(:total).is_greater_than_or_equal_to (0.01)}
  end
  context 'attributes' do
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:delivery_id).of_type(:integer) }
    it { should have_db_column(:status).of_type(:integer) }
    it { should have_db_column(:delivery_type).of_type(:string) }
    it { should have_db_column(:total).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { should have_db_column(:delivery_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { should have_db_column(:delivery_duration).of_type(:string) }
  end
end
