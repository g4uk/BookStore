# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'index', type: :feature do
  let(:user) { create(:user) }
  let(:waiting_order) { create(:order, status: :in_queue).decorate }
  let(:canceled_order) { create(:order, status: :canceled).decorate }
  let(:in_delivery_order) { create(:order, status: :in_delivery).decorate }
  let(:delivered_order) { create(:order, status: :delivered).decorate }
  let(:locale) { 'en' }

  before do
    login_as user
    waiting_order.status = :in_queue
    canceled_order.status = :canceled
    in_delivery_order.status = :in_delivery
    delivered_order.status = :delivered
    user.orders << waiting_order
    user.orders << canceled_order
    user.orders << in_delivery_order
    user.orders << delivered_order
    visit orders_path
  end

  it 'shows users orders' do
    expect(page).to have_content(waiting_order.formatted_total)
    expect(page).to have_content(canceled_order.formatted_total)
    expect(page).to have_content(in_delivery_order.formatted_total)
    expect(page).to have_content(delivered_order.formatted_total)
  end

  it 'has link to order page', js: true do
    allow_any_instance_of(AddressDecorator).to receive(:formatted_country).and_return waiting_order.billing_address.country
    within('tbody') do
      first('tr').click
      expect(current_path).to eq order_path(id: user.orders.sorted_paid.first.id, locale: locale)
    end
  end

  describe 'filtering' do
    context 'waiting for processing' do
      before do
        within('main') do
          first('.dropdown-toggle').click
          click_link 'Waiting for processing'
        end
      end

      it 'lists orders', js: true do
        expect(page).to have_content(waiting_order.formatted_total)
      end

      it 'doesnt list another orders', js: true do
        expect(page).not_to have_content(canceled_order.formatted_total)
      end
    end

    context 'in delivery' do
      before do
        within('main') do
          first('.dropdown-toggle').click
          click_link 'In Delivery'
        end
      end
      it 'lists orders', js: true do
        expect(page).to have_content(in_delivery_order.formatted_total)
      end

      it 'doesnt list another orders', js: true do
        expect(page).not_to have_content(canceled_order.formatted_total)
      end
    end

    context 'delivered' do
      before do
        within('main') do
          first('.dropdown-toggle').click
          click_link 'Delivered'
        end
      end
      it 'lists orders', js: true do
        expect(page).to have_content(delivered_order.formatted_total)
      end

      it 'doesnt list another orders', js: true do
        expect(page).not_to have_content(canceled_order.formatted_total)
      end
    end

    context 'canceled' do
      before do
        within('main') do
          first('.dropdown-toggle').click
          click_link 'Canceled'
        end
      end
      it 'lists orders', js: true do
        expect(page).to have_content(canceled_order.formatted_total)
      end

      it 'doesnt list another orders', js: true do
        expect(page).not_to have_content(delivered_order.formatted_total)
      end
    end
  end
end
