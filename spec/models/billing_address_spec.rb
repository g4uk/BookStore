# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillingAddress, type: :model do
  let(:billing_address) { FactoryBot.create :billing_address }
  let(:string_length) { 50 }
  let(:zip_length) { 10 }
  let(:phone_length) { 15 }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(PHONE) }

  it { expect(billing_address).to belong_to(:user) }
  it { expect(billing_address).to belong_to(:order) }
  it { expect(billing_address).to validate_presence_of(:first_name) }
  it { expect(billing_address).to validate_presence_of(:last_name) }
  it { expect(billing_address).to validate_presence_of(:address) }
  it { expect(billing_address).to validate_presence_of(:country) }
  it { expect(billing_address).to validate_presence_of(:city) }
  it { expect(billing_address).to validate_presence_of(:zip) }
  it { expect(billing_address).to validate_presence_of(:phone) }
  it { expect(billing_address).to validate_length_of(:first_name).is_at_most(string_length) }
  it { expect(billing_address).to validate_length_of(:last_name).is_at_most(string_length) }
  it { expect(billing_address).to validate_length_of(:address).is_at_most(string_length) }
  it { expect(billing_address).to validate_length_of(:country).is_at_most(string_length) }
  it { expect(billing_address).to validate_length_of(:city).is_at_most(string_length) }
  it { expect(billing_address).to validate_length_of(:zip).is_at_most(zip_length) }
  it { expect(billing_address).to validate_length_of(:phone).is_at_most(phone_length) }
  it { expect(billing_address).to allow_value(valid_name).for(:first_name) }
  it { expect(billing_address).to allow_value(valid_name).for(:last_name) }
  it { expect(billing_address).to allow_value(valid_name).for(:city) }
  it { expect(billing_address).to allow_value(valid_name).for(:country) }
  it { expect(billing_address).not_to allow_value(invalid_name).for(:first_name) }
  it { expect(billing_address).not_to allow_value(invalid_name).for(:last_name) }
  it { expect(billing_address).not_to allow_value(invalid_name).for(:city) }
  it { expect(billing_address).not_to allow_value(invalid_name).for(:country) }
end
