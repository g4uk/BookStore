# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryBot.create :category }
  let(:valid_name) { '8908asdasd asdasd989' }
  let(:invalid_name) { '8908asdasd %^%$%^#' }

  it { expect(category).to validate_presence_of(:name) }
  it { expect(category).to validate_uniqueness_of(:name) }
  it { expect(category).to have_many(:books).dependent(:destroy) }
  it { expect(category).to validate_length_of(:name).is_at_most(80) }
  it { expect(category).to allow_value(valid_name).for(:name) }
  it { expect(category).not_to allow_value(invalid_name).for(:name) }
end
