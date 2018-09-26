# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:coupon_length) { 10 }
  let(:valid_code) { FFaker::String.from_regexp(COUPON) }
  let(:invalid_code) { FFaker::Internet.disposable_email }

  context 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code).is_at_most(coupon_length) }
    it { should validate_numericality_of(:discount) }
    it { should allow_value(valid_code).for(:code) }
    it { should_not allow_value(invalid_code).for(:code) }
  end
  context 'attributes' do
    it { should have_db_column(:code).of_type(:string) }
    it { should have_db_column(:discount).of_type(:integer) }
  end
end
