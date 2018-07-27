# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryBot.create :book }
  let(:books_with_authors) { FactoryBot.create :books_with_authors }

  it { expect(book).to validate_presence_of(:title) }
  it { expect(book).to validate_presence_of(:category) }
  it { expect(book).to validate_presence_of(:price) }
  it { expect(book).to validate_numericality_of(:price) }
  it { expect(book).to allow_values(0.89, 89, 8767.89).for(:price) }
  it { expect(book).not_to allow_values('sddasd').for(:price) }
  it { expect(book).to belong_to(:category) }
  it { expect(book).to have_many(:books_authors).dependent(:destroy) }
  it { expect(books_with_authors).to have_many(:authors).through(:books_authors) }
end
