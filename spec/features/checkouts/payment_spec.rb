# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'payment', type: :feature do
  let(:user) { create(:user) }
  let!(:order) { create(:order, status: :in_progress) }
  let(:credit_card) { create(:credit_card) }
  let(:submit) { first('input[name="commit"]') }

  before do
    inject_session order_id: order.id
    login_as user
    visit 'en/checkouts/payment'
  end

  it 'is on the payment step', js: true do
    expect(current_path).to include('payment')
  end

  describe 'credit_card form' do
    context 'invalid number' do
      it 'shows error messages', js: true do
        within(first('.form-group')) do
          fill_in 'cardName', with: ''
        end
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
