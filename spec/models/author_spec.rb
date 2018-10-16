# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::PhoneNumber.phone_number }
  let(:name_length) { 50 }
  let(:author) { FactoryBot.create :author }

  context 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { expect(author).to validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    it { is_expected.to allow_value(valid_name).for(:first_name) }
    it { is_expected.to allow_value(valid_name).for(:last_name) }
    it { is_expected.not_to allow_value(invalid_name).for(:first_name) }
    it { is_expected.not_to allow_value(invalid_name).for(:last_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(name_length) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(name_length) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
  end
  context 'relations' do
    it { is_expected.to have_many(:books_authors).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:books_authors) }
  end
end
