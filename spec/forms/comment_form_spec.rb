require 'rails_helper'

COMMENT = %r/\A[a-zA-Z0-9\s\.!,;#$%&'*+\/=?^_`{\(|\)}~-]+{1,500}\Z/.freeze

RSpec.describe CommentForm, type: :model do
  let(:title_length) { 80 }
  let(:text_length) { 500 }
  let(:valid_string) { FFaker::String.from_regexp(COMMENT) }
  let(:invalid_string) { FFaker::Internet.disposable_email }
  let(:statuses) { {unprocessed: 0, approved: 1, rejected: 2} }

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
end
