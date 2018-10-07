require 'rails_helper'

RSpec.describe 'books/index.html.haml', type: :feature do
  let(:first_category) { create(:category_with_books) }
  let(:second_category) { create(:category_with_books) }
  let(:third_category) { create(:category_with_books) }
  let(:categories) { [first_category, second_category, third_category] }
  let(:user) { create(:user) }
  let(:locale) { 'en' }

  before do
    categories
  end

  describe 'catalog' do
    it 'has links to categories' do
      visit books_path
      categories.each do |category|
        within(first('main')) do
          text = "#{category.name} #{category.books.size}"
          first('.list-inline').find('a', text: text, exact_text: true).click
        end
        category.books.each do |book|
          expect(first('main')).to have_content(book.title)
        end
      end
    end

    context 'sorting' do
      let(:titles) { [] }

      before do
        visit books_path(locale: locale, params: { category: first_category })
      end

      def books_titles
        within('#books-container') do
          all('.general-thumb-info').each do |info|
            titles << info.first('p').text
          end
        end
      end

      def sorted_titles(sort_param)
        first_category.books.order(sort_param).map(&:title)
      end

      it 'sorts by price asc', js: true do
        first('.dropdowns.pull-right').first('.dropdown-toggle').click
        click_link 'Price Low To High'
        books_titles
        expect(titles).to eql(sorted_titles(:price))
      end

      it 'sorts by price desc', js: true do
        first('.dropdowns.pull-right').first('.dropdown-toggle').click
        click_link 'Price High To Low'
        books_titles
        expect(titles).to eql(sorted_titles('price desc'))
      end

      it 'sorts by title asc', js: true do
        first('.dropdowns.pull-right').first('.dropdown-toggle').click
        click_link 'Title A - Z'
        books_titles
        expect(titles).to eql(sorted_titles(:title))
      end

      it 'sorts by title desc', js: true do
        first('.dropdowns.pull-right').first('.dropdown-toggle').click
        click_link 'Title Z - A'
        books_titles
        expect(titles).to eql(sorted_titles('title desc'))
      end

      it 'sorts by created_at desc', js: true do
        first('.dropdowns.pull-right').first('.dropdown-toggle').click
        click_link 'Newest First'
        books_titles
        expect(titles).to eql(sorted_titles('created_at desc'))
      end
    end
  end
end
