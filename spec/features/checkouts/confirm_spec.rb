require 'rails_helper'

RSpec.describe 'checkout/address', type: :feature do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:book) { create(:book) }
  let(:delivery) { create(:delivery).decorate }
  let(:credit_card) { create(:credit_card) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }

  before do
    order.delivery_price = delivery.price
    login_as user
    visit book_path(id: book.id, locale: locale)
    first('input[name="commit"]').click
    first('.shop-link').click
    click_link 'Checkout'
    within(first('.mb-40')) do
      first('select').all(:css, 'option')[3].select_option
    end
    first('.checkbox-icon').click
    first('input[name="commit"]').click
    first('.radio-icon').click
    first('input[name="commit"]').click
    within(first('.form-group')) do
      fill_in 'cardName', with: credit_card.number
    end
    submit.click
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
