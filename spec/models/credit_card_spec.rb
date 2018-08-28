# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:valid_number) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:invalid_number) { FFaker::Lorem.word }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:valid_date) { '12/20' }
  let(:invalid_date) { FFaker::Lorem.word }

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:owner_name) }
    it { should validate_presence_of(:expiration_date) }
    it { should validate_length_of(:owner_name).is_at_most(50) }
    it { should allow_value(valid_number).for(:number) }
    it { should_not allow_value(invalid_number).for(:number) }
    it { should allow_value(valid_name).for(:owner_name) }
    it { should_not allow_value(invalid_name).for(:owner_name) }
    it { should allow_value(valid_date).for(:expiration_date) }
    it { should_not allow_value(invalid_date).for(:expiration_date) }
  end
  context 'relations' do
    it { should belong_to(:order) }
  end
  context 'attributes' do
    it { should have_db_column(:number).of_type(:string) }
    it { should have_db_column(:owner_name).of_type(:string) }
    it { should have_db_column(:expiration_date).of_type(:string) }
  end
end
