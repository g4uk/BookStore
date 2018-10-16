require 'rails_helper'

RSpec.describe 'forgot_password', type: :feature do
  let(:user) { create(:user) }
  let(:locale) { 'en' }
  let(:submit) { first('input[name="commit"]') }

  before do
    visit forgot_password_users_path
  end

  describe 'forgot_password form' do
    context 'valid input' do
      it 'sends email instructions', js: true do
        allow(Devise::Mailer).to receive(:reset_password_instructions).and_return( double('Devise::Mailer', deliver: true))
        within(first('.general-form')) do
          fill_in 'user_email', with: user.email
          submit.click
        end
        expect(current_path).to eq login_users_path
        expect(page).to have_content 'You will receive an email'
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

    it 'has cancel link' do
      click_link 'Cancel'
      expect(current_path).to eq login_users_path
    end
  end
end
