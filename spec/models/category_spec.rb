# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:valid_name) { '8908asdasd asdasd989' }
  let(:invalid_name) { '8908asdasd %^%$%^#' }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_most(80) }
    it { should allow_value(valid_name).for(:name) }
    it { should_not allow_value(invalid_name).for(:name) }
  end
  context 'relations' do
    it { should have_many(:books).dependent(:destroy) }
  end
  context 'attributes' do
    it { should have_db_column(:name).of_type(:string) }
  end
end
