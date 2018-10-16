require 'rails_helper'

RSpec.describe 'signup', type: :feature do
  let(:user) { User.new(email: FFaker::Internet.email, password: FFaker::String.from_regexp(PASSWORD_REGEXP)) }
  let(:customer) { create(:user) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }
  let(:form) { first('.mb-60').first('.general-form') }

  before do
    visit checkout_login_users_path
  end

  describe 'registration form' do
    context 'valid input' do
      it 'signs up user', js: true do
        within(form) do
          fill_in 'user_email', with: user.email
          submit.click
        end
        expect(current_path).to eq cart_path(id: 1, locale: locale)
        expect(page).to have_content 'Signed up successfully'
      end
    end

    context 'existing user' do
      it 'shows error notice', js: true do
        within(form) do
          fill_in 'user_email', with: customer.email
          submit.click
        end
        expect(page).to have_content 'Email has already been taken'
      end
    end

    context 'invalid input' do
      it 'shows error notice', js: true do
        within(form) do
          submit.click
        end
        expect(page).to have_content 'Email can\'t be blank'
      end
    end
  end
end
