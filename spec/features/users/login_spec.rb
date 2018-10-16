require 'rails_helper'

RSpec.describe 'login', type: :feature do
  let(:user) { create(:user) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }

  before do
    visit login_users_path
  end

  describe 'login form' do
    context 'valid input' do
      it 'signs in user', js: true do
        within(first('.general-form')) do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          submit.click
        end
        expect(current_path).to eq books_path
        expect(page).to have_content 'Signed in successfully'
      end
    end

    context 'invalid input' do
      it 'shows error notice', js: true do
        within(first('.general-form')) do
          submit.click
        end
        expect(page).to have_content 'Invalid Email or password.'
      end
    end

    it 'has link to restore password page' do
      click_link 'Forgot password?'
      expect(current_path).to eq forgot_password_users_path
    end
  end
end
