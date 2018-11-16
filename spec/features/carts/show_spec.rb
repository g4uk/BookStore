# frozen_string_literal: true

require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'show', type: :feature do
  let(:coupon) { create(:coupon) }
  let(:cart) { create(:cart, order_items_count: 1) }
  let(:cart_id) { cart.id }
  let(:order_item) { cart.order_items.first.decorate }
  let(:user) { create(:user) }

  before do
    inject_session cart_id: cart_id
    visit cart_path(id: cart_id)
  end

  describe 'order items' do
    it 'lists order items', js: true do
      expect(page).to have_content(order_item.book_name)
    end

    it 'destroys item', js: true do
      first('.close').click
      expect(page).to have_content('Cart Is Empty :(')
    end
  end

  describe 'coupon' do
    let(:submit) { first('input[name="commit"]') }

    context 'invalid input' do
      it 'shows error', js: true do
        within('#coupon-wrapper') do
          submit.click
        end
        expect(page).to have_content('Not Found')
      end
    end

    context 'valid input' do
      it 'shows error', js: true do
        within('#coupon-wrapper') do
          fill_in 'cart_coupon_code', with: coupon.code
          submit.click
        end
        expect(page).to have_content('Added Coupon')
      end
    end
  end

  describe 'link to checkout', js: true do
    context 'guest' do
      it 'goes to checkout_login' do
        click_link 'Checkout'
        expect(current_path).to eq new_quick_signup_path
      end
    end
    context 'signed in user', js: true do
      it 'goes to checkout' do
        login_as user
        click_link 'Checkout'
        expect(current_path).to eq '/en/checkouts/address'
      end
    end
  end
end
