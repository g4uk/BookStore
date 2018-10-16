require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:title_length) { 80 }
  let(:text_length) { 500 }
  let(:valid_string) { FFaker::String.from_regexp(COMMENT) }
  let(:invalid_string) { FFaker::Internet.disposable_email }
  let(:statuses) { {unprocessed: 0, approved: 1, rejected: 2} }

  context 'relations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to define_enum_for(:status).with(statuses) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:title).is_at_most(title_length) }
    it { is_expected.to validate_length_of(:text).is_at_most(text_length) }
    it { is_expected.to allow_value(valid_string).for(:title) }
    it { is_expected.not_to allow_value(invalid_string).for(:title) }
    it { is_expected.to allow_value(valid_string).for(:text) }
    it { is_expected.not_to allow_value(invalid_string).for(:text) }
  end

  context 'attributes' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:rating).of_type(:integer) }
    it { is_expected.to have_db_column(:text).of_type(:text) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
  end
end
