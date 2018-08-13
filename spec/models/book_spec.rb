# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryBot.create :book }
  let(:books_with_authors) { FactoryBot.create :books_with_authors }
  let(:books_with_comments) { FactoryBot.create :books_with_comments }
  let(:invalid_string) { 'sddasd' }
  let(:string_length) { 255 }
  let(:minimum_year) { 1902 }
  let(:this_year) { Date.today.year }

  it { expect(book).to validate_presence_of(:title) }
  it { expect(book).to validate_presence_of(:category) }
  it { expect(book).to validate_presence_of(:price) }
  it { expect(book).to validate_presence_of(:category_id) }
  it { expect(book).to validate_numericality_of(:price) }
  it { expect(book).to validate_uniqueness_of(:title) }
  it { expect(book).to allow_values(0.01, 89, 8767.89).for(:price) }
  it { expect(book).not_to allow_values(0, -1).for(:price) }
  it { expect(book).not_to allow_value(invalid_string).for(:price) }
  it { expect(book).to belong_to(:category) }
  it { expect(book).to have_many(:books_authors).dependent(:destroy) }
  it { expect(books_with_authors).to have_many(:authors).through(:books_authors) }
  it { expect(book).to validate_length_of(:title).is_at_most(string_length) }
  it { expect(book).to validate_length_of(:materials).is_at_most(string_length) }
  it { expect(book).to validate_length_of(:dimensions).is_at_most(string_length) }
  it { expect(book).to validate_inclusion_of(:publishing_year).in_range(minimum_year..this_year) }
  it { expect(book).to have_many(:order_items).dependent(:nullify) }
  it { expect(books_with_comments).to have_many(:comments).dependent(:destroy) }
end
