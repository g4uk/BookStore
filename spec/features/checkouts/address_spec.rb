# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'address', type: :feature do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:delivery) { create(:delivery) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }
  let(:billing_address) { user.billing_address }
  let(:shipping_address) { user.shipping_address }
  let(:addresses) { { 'billing_address': billing_address, 'shipping_address': shipping_address } }
  let(:form) { first("edit_order_#{order.id}") }
  let(:book) { create(:book) }

  before do
    order.delivery_price = delivery.price
    login_as user
    visit book_path(id: book.id, locale: locale)
    first('input[name="commit"]').click
    first('.shop-link').click
    click_link 'Checkout'
  end

  describe 'address form' do
    it 'is on the address step', js: true do
      expect(current_path).to include('address')
    end

    def fill_address_form
      fill_in 'firstName', with: billing_address.first_name
      fill_in 'lastName', with: billing_address.last_name
      fill_in 'address', with: billing_address.address
      fill_in 'city', with: billing_address.city
      fill_in 'zip', with: billing_address.zip
      first('select').all(:css, 'option')[3].select_option
    end

    context 'invalid address' do
      it 'shows error messages', js: true do
        within(first('.mb-40')) do
          fill_in 'address', with: ''
        end
        submit.click
        expect(page).to have_content('is invalid')
      end
    end

    context 'valid address' do
      it 'shows success message', js: true do
        within(first('.mb-40')) do
          fill_address_form
        end
        first('.checkbox-icon').click
        submit.click
        expect(current_path).to eq '/en/checkouts/delivery'
      end
    end

    context 'valid billing, invalid shipping' do
      it 'shows error message', js: true do
        within(first('.mb-60')) do
          fill_in 'address', with: ''
        end
        submit.click
        expect(page).to have_content('is invalid')
      end
    end
  end
end
