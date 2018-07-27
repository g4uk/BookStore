# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryBot.create :category }

  it { expect(category).to validate_presence_of(:name) }
  it { expect(category).to validate_uniqueness_of(:name) }
  it { expect(category).to have_many(:books).dependent(:destroy) }
end