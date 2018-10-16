require 'rails_helper'

RSpec.describe 'payment', type: :feature do
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
  end

  it 'is on the payment step', js: true do
    expect(current_path).to include('payment')
  end

  describe 'credit_card form' do
    context 'invalid number' do
      it 'shows error messages', js: true do
        submit.click
        expect(page).to have_content('is invalid')
      end
    end

    context 'valid number' do
      it 'goes to next step', js: true do
        within(first('.form-group')) do
          fill_in 'cardName', with: credit_card.number
        end
        submit.click
        expect(current_path).to eq '/en/checkouts/confirm'
      end
    end
  end
end
