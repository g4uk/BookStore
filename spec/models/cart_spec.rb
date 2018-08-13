require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { FactoryBot.create :cart }

  it { expect(cart).to have_many(:order_items).dependent(:nullify) }
end
