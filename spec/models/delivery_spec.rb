# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Delivery, type: :model do
  let(:delivery) { FactoryBot.create :delivery }
  let(:delivery_with_orders) { FactoryBot.create :delivery_with_orders }

  it { expect(delivery).to validate_presence_of(:name) }
  it { expect(delivery).to validate_presence_of(:duration) }
  it { expect(delivery).to validate_numericality_of(:price) }
  it { expect(delivery).to allow_values(0, 80.80).for(:price) }
  it { expect(delivery).not_to allow_value(-1).for(:price) }
  it { expect(delivery).to validate_length_of(:name).is_at_most(80) }
  it { expect(delivery).to validate_length_of(:duration).is_at_most(80) }
  it { expect(delivery_with_orders).to have_many(:orders).dependent(:nullify) }
end
