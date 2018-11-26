# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/show.html.haml', type: :feature do
  let(:user) { create(:user) }
  let!(:order) { create(:order, status: 6).decorate }
  let(:credit_card) { create(:credit_card) }
  let(:locale) { 'en' }

  before do
    allow_any_instance_of(AddressDecorator).to receive(:formatted_country).and_return order.billing_address.country
    login_as order.user
    order.status = 6
    credit_card.order_id = order.id
    visit order_path(id: order.id, locale: locale)
  end

  describe 'order info' do
    it 'shows shipping address' do
      expect(page).to have_content(order.shipping_address.first_name)
      expect(page).to have_content(order.shipping_address.last_name)
      expect(page).to have_content(order.shipping_address.city)
      expect(page).to have_content(order.shipping_address.zip)
      expect(page).to have_content(order.shipping_address.phone)
    end

    it 'shows billing address' do
      expect(page).to have_content(order.billing_address.first_name)
      expect(page).to have_content(order.billing_address.last_name)
      expect(page).to have_content(order.billing_address.city)
      expect(page).to have_content(order.billing_address.zip)
      expect(page).to have_content(order.billing_address.country)
      expect(page).to have_content(order.billing_address.phone)
    end

    it 'shows shipments' do
      expect(page).to have_content(order.delivery_type)
      expect(page).to have_content(order.delivery_duration)
      expect(page).to have_content(order.formatted_delivery_price)
    end

    it 'shows total' do
      expect(page).to have_content(order.formatted_total)
    end

    it 'shows payment info' do
      expect(page).to have_content(order.credit_card.number)
    end

    it 'lists order items' do
      order.order_items.each do |item|
        expect(page).to have_content(item.book_name)
      end
    end
  end
end
