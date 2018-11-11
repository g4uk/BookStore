# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'edit', type: :feature do
  let(:user) { create(:user) }
  let(:billing_address) { user.billing_address }
  let(:shipping_address) { user.shipping_address }
  let(:addresses) { { 'billing_address': billing_address, 'shipping_address': shipping_address } }
  let(:locale) { 'en' }
  let(:new_password) { FFaker::String.from_regexp(PASSWORD_REGEXP) }

  before do
    login_as user
    visit edit_user_path(id: user.id, locale: locale)
  end
  describe 'address tab' do
    context 'invalid address' do
      it 'shows error messages', js: true do
        addresses.each do |type, _address|
          within(first("#edit_#{type}_form_wrapper")) do
            fill_in 'address', with: ''
            first('input[name="commit"]').click
          end
          expect(first('.flash_message')).to have_content('Fix Errors')
        end
      end
    end

    context 'valid address' do
      it 'shows success message', js: true do
        addresses.each do |type, address|
          within(first("#edit_#{type}_form_wrapper")) do
            fill_in 'firstName', with: address.first_name
            fill_in 'lastName', with: address.last_name
            fill_in 'address', with: address.address
            fill_in 'city', with: address.city
            fill_in 'zip', with: address.zip
            first('select').all(:css, 'option')[3].select_option
            first('input[name="commit"]').click
          end
          expect(first('.flash_message')).to have_content('Updated Sucessfully')
        end
      end
    end
  end

  describe 'privacy tab' do
    let(:email_form) { first('#edit_email_form_wrapper') }
    let(:password_form) { first('#edit_password_form_wrapper') }
    let(:submit) { first('input[name="commit"]') }
    let(:flash) { first('.flash_message') }

    before do
      click_link 'Privacy'
    end

    describe 'email form' do
      context 'invalid email' do
        it 'shows error messages', js: true do
          within(email_form) do
            find('#email').native.clear
            submit.click
          end
          expect(flash).to have_content('Fix Errors')
        end
      end

      context 'valid email' do
        it 'shows error messages', js: true do
          within(email_form) do
            submit.click
          end
          expect(flash).to have_content('Updated Sucessfully')
        end
      end
    end

    describe 'password form' do
      context 'invalid password' do
        it 'shows error messages', js: true do
          within(password_form) do
            fill_in 'password', with: user.password
            fill_in 'password_confirmation', with: user.password
            find('#current_password').click # hiding tooltip
            submit.click
          end
          expect(flash).to have_content('Fix Errors')
        end
      end

      context 'valid email' do
        it 'shows error messages', js: true do
          within(password_form) do
            fill_in 'current_password', with: user.password
            fill_in 'password', with: new_password
            fill_in 'password_confirmation', with: new_password
            find('#current_password').click
            submit.click
          end
          expect(flash).to have_content('Updated Sucessfully')
        end
      end
    end

    describe 'remove account' do
      it 'destroys user', js: true do
        first('.checkbox-icon').click
        click_link 'Please, remove my account'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Your account was successfully destroyed'
      end
    end
  end
end
