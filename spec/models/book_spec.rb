# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:string_length) { 255 }
  let(:minimum_year) { 1902 }
  let(:this_year) { Date.today.year }
  let(:book) { FactoryBot.create :book }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { expect(book).to validate_uniqueness_of(:title) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to (0.01)}
    it { should validate_length_of(:title).is_at_most(string_length) }
    it { should validate_length_of(:materials).is_at_most(string_length) }
    it { should validate_inclusion_of(:publishing_year).in_range(minimum_year..this_year) }
  end
  context 'relations' do
    it { should have_many(:order_items).dependent(:nullify) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:category) }
    it { should have_many(:images).dependent(:destroy) }
    it { should have_many(:books_authors).dependent(:destroy) }
    it { should have_many(:authors).through(:books_authors) }
  end
  context 'attributes' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:category_id).of_type(:integer) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:price).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { should have_db_column(:publishing_year).of_type(:integer) }
    it { should have_db_column(:dimensions).of_type(:text) }
    it { should have_db_column(:materials).of_type(:string) }
    it { should have_db_column(:comments_count).of_type(:integer) }
  end
end
