require 'rails_helper'

RSpec.describe 'signup', type: :feature do
  let(:user) { User.new(email: FFaker::Internet.email, password: FFaker::String.from_regexp(PASSWORD_REGEXP)) }
  let(:customer) { create(:user) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }

  before do
    visit signup_users_path
  end

  describe 'registration form' do
    context 'valid input' do
      it 'signs up user', js: true do
        within(first('.general-form')) do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          fill_in 'user_password_confirmation', with: user.password
          submit.click
        end
        expect(current_path).to eq books_path
        expect(page).to have_content 'signed up successfully.'
      end
    end

    context 'existing user' do
      it 'shows error notice', js: true do
        within(first('.general-form')) do
          fill_in 'user_email', with: customer.email
          fill_in 'user_password', with: customer.password
          fill_in 'user_password_confirmation', with: customer.password
          submit.click
        end
        expect(page).to have_content 'Email has already been taken'
      end
    end

    context 'invalid input' do
      it 'shows error notice', js: true do
        within(first('.general-form')) do
          submit.click
        end
        expect(page).to have_content 'Email can\'t be blank'
      end
    end

    it 'has link to login page' do
      within(first('.general-main-wrap')) do
        click_link 'Log In'
      end
      expect(current_path).to eq login_users_path
    end
  end
end
