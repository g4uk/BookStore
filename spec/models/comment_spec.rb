require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:title_length) { 80 }
  let(:text_length) { 500 }
  let(:valid_string) { FFaker::String.from_regexp(COMMENT) }
  let(:invalid_string) { '' }

  context 'relations' do
    it { should belong_to(:book) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
    it { should validate_length_of(:title).is_at_most(title_length) }
    it { should validate_length_of(:text).is_at_most(text_length) }
    it { should allow_value(%w(true false)).for(:status) }
    it { should allow_value(valid_string).for(:title) }
    it { should_not allow_value(invalid_string).for(:title) }
    it { should allow_value(valid_string).for(:text) }
    it { should_not allow_value(invalid_string).for(:text) }
  end

  context 'attributes' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:rating).of_type(:integer) }
    it { should have_db_column(:text).of_type(:text) }
    it { should have_db_column(:status).of_type(:boolean) }
  end
end
