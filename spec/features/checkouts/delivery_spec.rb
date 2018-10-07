require 'rails_helper'

RSpec.describe 'checkout/address', type: :feature do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:book) { create(:book) }
  let(:delivery) { create(:delivery).decorate }
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
  end

  it 'is on the delivery step', js: true do
    expect(current_path).to include('delivery')
  end

  it 'goes to next step', js: true do
    first('.radio-icon').click
    submit.click
    expect(current_path).to eq '/en/checkouts/payment'
  end
end
