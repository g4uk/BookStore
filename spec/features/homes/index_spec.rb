require 'rails_helper'

RSpec.describe 'homes/index.html.haml', type: :feature do
  let(:category) { create(:category) }
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  before do
    book
    visit root_path
  end

  it 'has link to catalog' do
    click_link 'Get Started'
    expect(current_path).to eq books_path
  end

  it 'shows latest books in carousel' do
    expect(first('#slider')).to have_content(book.title)
  end

  it 'has link to book page', js: true do
    first('.general-thumb-wrap').hover
    expect(page).to have_selector('.link-to-book')
    click_link first('.link-to-book')
    expect(current_path).to eq book_path(book.id)
  end

  describe 'header menu' do
    let(:header_navbar) { first('#navbar').first('.hidden-xs') }
    let(:shop_dropdown) { header_navbar.first('.dropdown-menu') }

    it 'has link to home page' do
      within(header_navbar) do
        click_link 'Home'
      end
      expect(current_path).to eq root_path
    end

    it 'has link to category' do
      within(shop_dropdown) do
        click_link "#{book.category.name} (#{book.category.books.size})"
      end
      expect(current_path).to eq books_path
    end

    it 'has cart' do
      expect(first('.shop-link').first('.shop-icon')).to be_a(Capybara::Node::Element)
    end

    context 'user not signed in' do
      it 'has link to login page' do
        within(header_navbar) do
          click_link 'Log In'
        end
        expect(current_path).to eq login_users_path
      end

      it 'has link to registration page' do
        within(header_navbar) do
          click_link 'Sign Up'
        end
        expect(current_path).to eq signup_users_path
      end
    end

    context 'user is signed in' do
      let(:account_dropdown) { header_navbar.all('.dropdown-menu').last }

      before do
        login_as user
        visit root_path
      end

      it 'has link to account settings' do
        within(account_dropdown) do
          click_link 'Settings'
        end
        expect(current_path).to eq "/en/users/edit/#{user.id}"
      end

      it 'has link to orders list' do
        within(account_dropdown) do
          click_link 'Orders'
        end
        expect(current_path).to eq orders_path
      end

      it 'has link to log out' do
        within(account_dropdown) do
          click_link 'Log Out'
        end
        expect(current_path).to eq root_path
        expect(page).to have_content 'Signed out successfully'
      end
    end
  end

  describe 'footer menu' do
    let(:footer_navbar) { first('footer').first('.list-inline') }

    it 'has link to home page' do
      within(footer_navbar) do
        click_link 'Home'
      end
      expect(current_path).to eq root_path
    end

    context 'user not signed in' do
      it 'has link to login page' do
        within(footer_navbar) do
          click_link 'Log In'
        end
        expect(current_path).to eq login_users_path
      end

      it 'has link to registration page' do
        within(footer_navbar) do
          click_link 'Sign Up'
        end
        expect(current_path).to eq signup_users_path
      end
    end

    context 'user is signed in' do
      before do
        login_as user
        visit root_path
      end

      it 'has link to account settings' do
        within(footer_navbar) do
          click_link 'Settings'
        end
        expect(current_path).to eq "/en/users/edit/#{user.id}"
      end

      it 'has link to orders list' do
        within(footer_navbar) do
          click_link 'Orders'
        end
        expect(current_path).to eq orders_path
      end
    end
  end
end
