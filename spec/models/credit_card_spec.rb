# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:valid_number) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:invalid_number) { FFaker::Lorem.word }

  context 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to allow_value(valid_number).for(:number) }
    it { is_expected.not_to allow_value(invalid_number).for(:number) }
  end
  context 'relations' do
    it { is_expected.to belong_to(:order) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:number).of_type(:string) }
    it { is_expected.to have_db_column(:order_id).of_type(:integer) }
  end
end
