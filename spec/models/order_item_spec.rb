# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryBot.create :order_item }

  it { expect(order_item).to belong_to(:book) }
  it { expect(order_item).to belong_to(:cart) }
  it { expect(order_item).to belong_to(:order) }
end
