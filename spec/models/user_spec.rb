# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:valid_password) { FFaker::String.from_regexp(PASSWORD_REGEXP) }
  let(:invalid_password) { '89%^%$%^#' }
  let(:valid_email) { FFaker::Internet.email }
  let(:invalid_email) { FFaker::Lorem.word }

  it { expect(user).to have_many(:comments).dependent(:destroy) }
  it { expect(user).to have_many(:orders).dependent(:nullify) }
  it { expect(user).to have_many(:addresses).dependent(:destroy) }
  it { expect(user).to allow_value(valid_password).for(:password) }
  it { expect(user).not_to allow_value(invalid_password).for(:password) }
  it { expect(user).to allow_value(valid_email).for(:email) }
  it { expect(user).not_to allow_value(invalid_email).for(:email) }
end
