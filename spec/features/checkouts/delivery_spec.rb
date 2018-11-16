# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'checkout/address', type: :feature do
  let(:user) { create(:user) }
  let(:order) { create(:order, status: :shipping) }
  let(:book) { create(:book) }
  let(:delivery) { create(:delivery).decorate }
  let(:submit) { first('input[name="commit"]') }

  before do
    inject_session order_id: order.id
    order.delivery_price = delivery.price
    login_as user
    visit 'en/checkouts/delivery'
  end

  it 'is on the delivery step', js: true do
    expect(current_path).to include('delivery')
  end

  it 'shows error message', js: true do
    submit.click
    expect(current_path).to eq '/en/checkouts/delivery'
    expect(page).to have_content('You should to choose shipping method')
  end

  it 'goes to next step', js: true do
    first('.radio-icon').click
    submit.click
    expect(current_path).to eq '/en/checkouts/payment'
  end
end
