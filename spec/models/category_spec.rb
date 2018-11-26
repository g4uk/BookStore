# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:valid_name) { FFaker::String.from_regexp(CATEGORY) }
  let(:invalid_name) { FFaker::PhoneNumber.phone_calling_code }
  let(:category) { FactoryBot.create :category }
  let(:name_length) { 80 }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { expect(category).to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(name_length) }
    it { is_expected.to allow_value(valid_name).for(:name) }
    it { is_expected.not_to allow_value(invalid_name).for(:name) }
  end

  context 'relations' do
    it { is_expected.to have_many(:books).dependent(:destroy) }
  end

  context 'attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:books_count).of_type(:integer) }
  end
end
