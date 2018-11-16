# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'confirm', type: :feature do
  let(:user) { create(:user) }
  let(:order) { create(:order, status: :payment) }
  let(:submit) { first('input[name="commit"]') }

  before do
    inject_session order_id: order.id
    login_as user
    visit 'en/checkouts/confirm'
  end

  it 'is on the confirm step', js: true do
    expect(current_path).to include('confirm')
  end

  describe 'order information' do
    it 'has info about billing address', js: true do
      expect(page).to have_content('Billing Address')
    end

    it 'has info about shipping address', js: true do
      expect(page).to have_content('Shipping Address')
    end

    it 'has info about shipment method', js: true do
      expect(page).to have_content('Shipments')
    end

    it 'has info about shipment method', js: true do
      expect(page).to have_content('Payment Information')
    end
  end

  describe 'edit links' do
    it 'has link to edit addresses', js: true do
      first(:xpath, "//a[contains(@href,'/en/checkouts/address')]").click
      expect(current_path).to include('address')
    end

    it 'has link to edit shipment', js: true do
      find(:xpath, "//a[contains(@href,'/en/checkouts/delivery')]").click
      expect(current_path).to include('delivery')
    end

    it 'has link to edit payment info', js: true do
      find(:xpath, "//a[contains(@href,'/en/checkouts/payment')]").click
      expect(current_path).to include('payment')
    end
  end
end
