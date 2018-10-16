# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_password) { FFaker::String.from_regexp(PASSWORD_REGEXP) }
  let(:invalid_value) { FFaker::PhoneNumber.phone_calling_code }
  let(:valid_email) { FFaker::Internet.email }

  context 'relations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:nullify) }
    it { is_expected.to have_one(:billing_address).dependent(:destroy) }
    it { is_expected.to have_one(:shipping_address).dependent(:destroy) }
  end
  context 'validations' do
    it { is_expected.to allow_value(valid_password).for(:password) }
    it { is_expected.not_to allow_value(invalid_value).for(:password) }
    it { is_expected.to allow_value(valid_email).for(:email) }
    it { is_expected.not_to allow_value(invalid_value).for(:email) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:provider).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:image).of_type(:text) }
  end
end
