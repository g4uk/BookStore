require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should have_many(:order_items).dependent(:nullify) }
end
