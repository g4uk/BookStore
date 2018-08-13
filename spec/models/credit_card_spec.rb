# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryBot.create :credit_card }
  let(:valid_number) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:invalid_number) { FFaker::Lorem.word }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  let(:valid_date) { '12/20' }
  let(:invalid_date) { FFaker::Lorem.word }

  it { expect(credit_card).to validate_presence_of(:number) }
  it { expect(credit_card).to validate_presence_of(:owner_name) }
  it { expect(credit_card).to validate_presence_of(:expiration_date) }
  it { expect(credit_card).to validate_length_of(:owner_name).is_at_most(50) }
  it { expect(credit_card).to allow_value(valid_number).for(:number) }
  it { expect(credit_card).not_to allow_value(invalid_number).for(:number) }
  it { expect(credit_card).to allow_value(valid_name).for(:owner_name) }
  it { expect(credit_card).not_to allow_value(invalid_name).for(:owner_name) }
  it { expect(credit_card).to allow_value(valid_date).for(:expiration_date) }
  it { expect(credit_card).not_to allow_value(invalid_date).for(:expiration_date) }
  it { expect(credit_card).to belong_to(:order) }
end
