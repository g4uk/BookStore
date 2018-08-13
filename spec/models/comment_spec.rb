require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.create :comment }
  let(:title_length) { 80 }
  let(:text_length) { 500 }
  let(:valid_string) { FFaker::String.from_regexp(COMMENT) }
  let(:invalid_string) { '' }

  it { expect(comment).to belong_to(:book) }
  it { expect(comment).to belong_to(:user) }
  it { expect(comment).to validate_presence_of(:title) }
  it { expect(comment).to validate_presence_of(:text) }
  it { expect(comment).to validate_length_of(:title).is_at_most(title_length) }
  it { expect(comment).to validate_length_of(:text).is_at_most(text_length) }
  it { expect(comment).to allow_value(%w(true false)).for(:status) }
  it { expect(comment).to allow_value(valid_string).for(:title) }
  it { expect(comment).not_to allow_value(invalid_string).for(:title) }
  it { expect(comment).to allow_value(valid_string).for(:text) }
  it { expect(comment).not_to allow_value(invalid_string).for(:text) }
end
