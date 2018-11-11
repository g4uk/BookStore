# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'relations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:itemable) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:book_name).of_type(:string) }
    it { is_expected.to have_db_column(:book_price).of_type(:decimal).with_options(precision: 8, scale: 2) }
  end
  context 'validations' do
    it { is_expected.to validate_presence_of(:book_name) }
    it { is_expected.to validate_presence_of(:total) }
    it { is_expected.to validate_presence_of(:book_price) }
    it { is_expected.to validate_numericality_of(:book_price).is_greater_than_or_equal_to 0.01 }
    it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to 0.01 }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to 1 }
  end
end
