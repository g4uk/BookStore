# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { FactoryBot.create :author }
  let(:author_with_books) { FactoryBot.create :author_with_books }
  let(:valid_name) { FFaker::String.from_regexp(NAME) }
  let(:invalid_name) { FFaker::String.from_regexp(PHONE) }
  let(:name_length) { 50 }

  it { expect(author).to validate_presence_of(:first_name) }
  it { expect(author).to validate_presence_of(:last_name) }
  it { expect(author).to validate_uniqueness_of(:first_name).scoped_to(:last_name) }
  it { expect(author).to have_many(:books_authors).dependent(:destroy) }
  it { expect(author_with_books).to have_many(:books).through(:books_authors) }
  it { expect(author).to allow_value(valid_name).for(:first_name) }
  it { expect(author).to allow_value(valid_name).for(:last_name) }
  it { expect(author).not_to allow_value(invalid_name).for(:first_name) }
  it { expect(author).not_to allow_value(invalid_name).for(:last_name) }
  it { expect(author).to validate_length_of(:first_name).is_at_most(name_length) }
  it { expect(author).to validate_length_of(:last_name).is_at_most(name_length) }
end
