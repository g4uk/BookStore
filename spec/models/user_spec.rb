# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_password) { FFaker::String.from_regexp(PASSWORD_REGEXP) }
  let(:invalid_password) { '89%^%$%^#' }
  let(:valid_email) { FFaker::Internet.email }
  let(:invalid_email) { FFaker::Lorem.word }

  context 'relations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:orders).dependent(:nullify) }
    it { should have_many(:addresses).dependent(:destroy) }
  end
  context 'validations' do
    it { should allow_value(valid_password).for(:password) }
    it { should_not allow_value(invalid_password).for(:password) }
    it { should allow_value(valid_email).for(:email) }
    it { should_not allow_value(invalid_email).for(:email) }
  end
  context 'attributes' do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
  end
end
