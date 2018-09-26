# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Delivery, type: :model do

  let(:name_length) { 80 }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to (0)}
    it { should validate_length_of(:name).is_at_most(name_length) }
    it { should validate_length_of(:duration).is_at_most(name_length) }
  end
  context 'relations' do
    it { should have_many(:orders).dependent(:nullify) }
  end
  context 'attributes' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:duration).of_type(:string) }
    it { should have_db_column(:price).of_type(:decimal).with_options(precision: 6, scale: 2) }
  end
end
