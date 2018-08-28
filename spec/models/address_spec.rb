# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillingAddress, type: :model do
  let(:string_length) { 50 }
  let(:zip_length) { 10 }
  let(:phone_length) { 15 }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(PHONE) }

  context 'validations' do
    it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:zip) }
  it { should validate_presence_of(:phone) }
  it { should validate_length_of(:first_name).is_at_most(string_length) }
  it { should validate_length_of(:last_name).is_at_most(string_length) }
  it { should validate_length_of(:address).is_at_most(string_length) }
  it { should validate_length_of(:country).is_at_most(string_length) }
  it { should validate_length_of(:city).is_at_most(string_length) }
  it { should validate_length_of(:zip).is_at_most(zip_length) }
  it { should validate_length_of(:phone).is_at_most(phone_length) }
  it { should allow_value(valid_name).for(:first_name) }
  it { should allow_value(valid_name).for(:last_name) }
  it { should allow_value(valid_name).for(:city) }
  it { should allow_value(valid_name).for(:country) }
  it { should_not allow_value(invalid_name).for(:first_name) }
  it { should_not allow_value(invalid_name).for(:last_name) }
  it { should_not allow_value(invalid_name).for(:city) }
  it { should_not allow_value(invalid_name).for(:country) }
  end
  context 'attributes' do
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:address).of_type(:string) }
    it { should have_db_column(:country).of_type(:string) }
    it { should have_db_column(:city).of_type(:string) }
    it { should have_db_column(:zip).of_type(:string) }
    it { should have_db_column(:phone).of_type(:string) }
    it { should have_db_column(:type).of_type(:string) }
  end
  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:order) }
  end
end
