# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:valid_number) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:invalid_number) { FFaker::Lorem.word }

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should allow_value(valid_number).for(:number) }
    it { should_not allow_value(invalid_number).for(:number) }
  end
  context 'relations' do
    it { should belong_to(:order) }
  end
  context 'attributes' do
    it { should have_db_column(:number).of_type(:string) }
    it { should have_db_column(:order_id).of_type(:integer) }
  end
end
