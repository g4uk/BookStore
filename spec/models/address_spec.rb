# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillingAddress, type: :model do
  let(:string_length) { 50 }
  let(:zip_length) { 10 }
  let(:phone_length) { 15 }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:valid_phone) { FFaker::PhoneNumber.phone_calling_code }
  let(:valid_zip) { FFaker::String.from_regexp(ZIP) }
  let(:valid_address) { FFaker::String.from_regexp(ADDRESS) }
  let(:invalid_address) { '@' }

  context 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:zip) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(string_length) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(string_length) }
    it { is_expected.to validate_length_of(:address).is_at_most(string_length) }
    it { is_expected.to validate_length_of(:country).is_at_most(string_length) }
    it { is_expected.to validate_length_of(:city).is_at_most(string_length) }
    it { is_expected.to validate_length_of(:zip).is_at_most(zip_length) }
    it { is_expected.to validate_length_of(:phone).is_at_most(phone_length) }
    it { is_expected.to allow_value(valid_name).for(:first_name) }
    it { is_expected.to allow_value(valid_name).for(:last_name) }
    it { is_expected.to allow_value(valid_name).for(:city) }
    it { is_expected.to allow_value(valid_name).for(:country) }
    it { is_expected.to allow_value(valid_phone).for(:phone) }
    it { is_expected.to allow_value(valid_zip).for(:zip) }
    it { is_expected.to allow_value(valid_address).for(:address) }
    it { should_not allow_value(valid_phone).for(:first_name) }
    it { should_not allow_value(valid_phone).for(:last_name) }
    it { should_not allow_value(valid_phone).for(:city) }
    it { should_not allow_value(valid_phone).for(:country) }
    it { should_not allow_value(valid_name).for(:phone) }
    it { should_not allow_value(valid_name).for(:zip) }
    it { should_not allow_value(invalid_address).for(:address) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:address).of_type(:string) }
    it { is_expected.to have_db_column(:country).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:zip).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:addressable_id).of_type(:integer) }
    it { is_expected.to have_db_column(:addressable_type).of_type(:string) }
  end
  context 'relations' do
    it { is_expected.to belong_to(:addressable) }
  end
end
