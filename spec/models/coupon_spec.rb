# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:coupon_length) { 10 }
  let(:valid_code) { FFaker::String.from_regexp(COUPON) }
  let(:invalid_code) { FFaker::Internet.disposable_email }

  context 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_length_of(:code).is_at_most(coupon_length) }
    it { is_expected.to validate_numericality_of(:discount) }
    it { is_expected.to allow_value(valid_code).for(:code) }
    it { is_expected.not_to allow_value(invalid_code).for(:code) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:code).of_type(:string) }
    it { is_expected.to have_db_column(:discount).of_type(:integer) }
  end
end
