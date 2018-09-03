# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'relations' do
    it { should belong_to(:book) }
    it { should belong_to(:cart) }
    it { should belong_to(:order) }
  end
  context 'attributes' do
    it { should have_db_column(:quantity).of_type(:integer) }
    it { should have_db_column(:book_name).of_type(:string) }
    it { should have_db_column(:book_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
  end
  context 'validations' do
    it { should validate_presence_of(:book_name) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:book_price) }
    it { should validate_numericality_of(:book_price).is_greater_than_or_equal_to (0.01)}
  end
end
