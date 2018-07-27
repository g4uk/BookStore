# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { FactoryBot.create :author }
  let(:author_with_books) { FactoryBot.create :author_with_books }

  it { expect(author).to validate_presence_of(:first_name) }
  it { expect(author).to validate_presence_of(:last_name) }
  it { expect(author).to validate_uniqueness_of(:first_name).scoped_to(:last_name) }
  it { expect(author).to have_many(:books_authors).dependent(:destroy) }
  it { expect(author_with_books).to have_many(:books).through(:books_authors) }
end
