require 'rails_helper'

RSpec.describe 'index', type: :feature do
  let(:user) { create(:user) }
  let(:waiting_order) { create(:order, status: 5).decorate }
  let(:canceled_order) { create(:order, status: 8).decorate }
  let(:in_delivery_order) { create(:order, status: 6).decorate }
  let(:delivered_order) { create(:order, status: 7).decorate }
  let(:locale) { 'en' }

  before do
    login_as user
    waiting_order.status = 5
    canceled_order.status = 8
    in_delivery_order.status = 6
    delivered_order.status = 7
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
