# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:valid_code) { '8908ADRE' }
  let(:invalid_code) { '89%^%$%^#' }

  context 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code).is_at_most(10) }
    it { should validate_numericality_of(:discount) }
    it { should allow_value(valid_code).for(:code) }
    it { should_not allow_value(invalid_code).for(:code) }
  end
  context 'attributes' do
    it { should have_db_column(:code).of_type(:string) }
    it { should have_db_column(:discount).of_type(:integer) }
  end
end
