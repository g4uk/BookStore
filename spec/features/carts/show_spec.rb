require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'carts/show.html.haml', type: :feature do
  let(:coupon) { create(:coupon) }
  let(:user) { create(:user) }
  let(:locale) { 'en' }
  let(:book) { create(:book).decorate }
  let(:subtotal) { first('.item-subtotal').text }

  before do
    visit book_path(id: book.id, locale: locale)
    2.times { first('input[name="commit"]').click }
    first('.shop-link').click
  end

  describe 'order items' do
    def formatted_price
      number_to_currency(book.price * 2, precizion: 2)
    end

    it 'lists order items', js: true do
      expect(page).to have_content(book.title)
    end

    it 'increments item quantity', js: true do
      first('.increment').click
      expect(subtotal).to eql formatted_price
    end

    it 'decrements item quantity', js: true do
      first('.decrement').click
      expect(subtotal).to eql formatted_price
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
        expect(current_path).to eq checkout_login_users_path
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
