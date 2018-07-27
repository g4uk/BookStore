# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksAuthor, type: :model do
  let(:books_author) { FactoryBot.create :books_author }

  it { expect(books_author).to validate_presence_of(:book) }
  it { expect(books_author).to validate_presence_of(:author) }
  it { expect(books_author).to belong_to(:book) }
  it { expect(books_author).to belong_to(:author) }
end
