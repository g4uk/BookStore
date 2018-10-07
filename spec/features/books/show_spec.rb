require 'rails_helper'

RSpec.describe 'books/show.html.haml', type: :feature do
  let(:category) { create(:category) }
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let(:locale) { 'en' }
  let(:comment_form_wrapper) { first('#comment_form_wrapper') }
  let(:submit) { first('input[name="commit"]') }
  let(:comment) { create(:comment) }
  let(:approved_comment) { create(:comment, status: 1) }

  before do
    approved_comment.status = 1
    book.comments << approved_comment
    login_as user
    book
    visit book_path(id: book.id, locale: locale)
  end

  it 'has link to catalog' do
    click_link 'Back To Results'
    expect(current_path).to eq books_path
  end

  it 'shows full description' do
    click_link 'Read more'
    expect(first('.full-descr')).to have_content(book.description)
  end

  it 'shows approved comments' do
    expect(page).to have_content(approved_comment.text)
  end

  describe 'order_item form' do
    let(:quantity_input) { first('#order_item_quantity') }

    it 'increments quantity', js: true do
      first('.increment').click
      expect(quantity_input.value).to eq '2'
    end

    it 'adds book to cart', js: true do
      4.times { first('input[name="commit"]').click }
      expect(first('.shop-quantity')).to have_content('4')
    end

    it 'decrements quantity', js: true do
      first('.decrement').click
      expect(quantity_input.value).to eq '1'
    end

    context 'minimal quantity' do
      it 'doesnt decrement quantity', js: true do
        first('.decrement').click
        expect(quantity_input.value).to eq '1'
      end
    end
  end

  describe 'comment form' do
    context 'invalid comment' do
      it 'shows error messages', js: true do
        within(comment_form_wrapper) do
          submit.click
        end
        expect(first('.flash_message')).to have_content('Fix Errors')
      end
    end

    context 'valid comment' do
      it 'shows alert', js: true do
        first('.rating_wrapper').all('.fa-star').each { |star| star.click }
        within(comment_form_wrapper) do
          fill_in 'title', with: comment.title
          fill_in 'review', with: comment.text
          submit.click
        end
        expect(accept_alert).to eq('Thanks for Review. It will be published as soon as Admin will approve it.')
      end
    end
  end
end
