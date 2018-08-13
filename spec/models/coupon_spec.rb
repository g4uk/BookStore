# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:coupon) { FactoryBot.create :coupon }
  let(:valid_code) { '8908ADRE' }
  let(:invalid_code) { '89%^%$%^#' }

  it { expect(coupon).to validate_presence_of(:code) }
  it { expect(coupon).to validate_length_of(:code).is_at_most(10) }
  it { expect(coupon).to validate_numericality_of(:discount) }
  it { expect(coupon).to allow_value(valid_code).for(:code) }
  it { expect(coupon).not_to allow_value(invalid_code).for(:code) }
end
