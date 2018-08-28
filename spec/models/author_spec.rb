# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(PHONE) }
  let(:name_length) { 50 }

  context 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    it { should allow_value(valid_name).for(:first_name) }
    it { should allow_value(valid_name).for(:last_name) }
    it { should_not allow_value(invalid_name).for(:first_name) }
    it { should_not allow_value(invalid_name).for(:last_name) }
    it { should validate_length_of(:first_name).is_at_most(name_length) }
    it { should validate_length_of(:last_name).is_at_most(name_length) }
  end
  context 'attributes' do
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
  end
  context 'relations' do
    it { should have_many(:books_authors).dependent(:destroy) }
    it { should have_many(:books).through(:books_authors) }
  end
end
