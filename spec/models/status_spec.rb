# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:status) { FactoryBot.create :status }
  let(:status_with_orders) { FactoryBot.create :status_with_orders }

  it { expect(status).to validate_presence_of(:name) }
  it { expect(status_with_orders).to have_many(:orders).dependent(:nullify) }
end

