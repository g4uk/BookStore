# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressDecorator do
  let(:order) { create(:order) }
  let(:billing_address) { order.billing_address.decorate }

  it 'formats name' do
    expect(billing_address.formatted_name).to eql("#{billing_address.first_name} #{billing_address.last_name}")
  end

  it 'formats city' do
    expect(billing_address.formatted_city).to eql("#{billing_address.city} #{billing_address.zip}")
  end

  it 'formats phone' do
    expect(billing_address.formatted_phone).to eql("Phone #{billing_address.phone}")
  end

  it 'formats address' do
    expect(billing_address.formatted_address).to eql(billing_address.address.address)
  end
end
