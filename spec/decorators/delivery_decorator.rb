require 'rails_helper'

RSpec.describe DeliveryDecorator do
  include ActionView::Helpers::NumberHelper

  let(:delivery) { create(:delivery).decorate }

  it 'formats price' do
    price = number_to_currency(delivery.price, precizion: 2)
    expect(delivery.formatted_price).to eql(price)
  end
end
