# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  SORT_CONDITIONS = ['created_at desc',
                     'popular',
                     'price asc',
                     'price desc',
                     'title asc',
                     'title desc'].freeze

  let(:sort_conditions) { SORT_CONDITIONS }
  let(:sort_params) { sort_conditions.sample }
  let(:category_id) { create(:category).id }
  let(:page) { '1' }
  let(:book) { create(:book) }
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(200)
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'renders js' do
      get 'index', xhr: true, params: { sort: sort_params, category: category_id, page: page }
      expect(response.code).to eql('200')
    end

    context 'assigns' do
      it 'assigns @books' do
        get :index, params: { sort: sort_params, category: category_id, page: page }
        books = SortBooksQuery.new(sort_params: sort_params, category_id: category_id, page: page).call
        assert_equal BookDecorator.decorate_collection(books), assigns(:books)
      end

      it 'assigns @sort_presenter' do
        get :show, params: { id: book.id }
        expect(assigns(:sort_presenter)).to be_a SortPresenter
      end
    end

    context 'decorators' do
      it 'decorates cart' do
        get :index
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates book' do
        get :index
        expect(assigns(:books)).to be_decorated_with PaginatingDecorator
      end
    end
  end

  describe 'GET #show' do
    before do
      allow(Book).to receive(:find).and_return book
    end

    it 'returns http success' do
      get :show, params: { id: book.id }
      expect(response).to have_http_status('200')
    end

    it 'renders show template' do
      get :show, params: { id: book.id }
      expect(response).to render_template(:show)
    end

    it 'loads images with book' do
      expect(book.association(:images)).to be_loaded
    end

    context 'assigns' do
      before do
        get :show, params: { id: book.id }
      end

      it 'assigns @book' do
        assert_equal book, assigns(:book)
      end

      it 'assigns @comment_form' do
        expect(assigns(:comment_form)).not_to be_nil
      end

      it 'assigns @reviews' do
        expect(assigns(:reviews)).not_to be_nil
      end

      it 'assigns @order_item' do
        expect(assigns(:order_item)).not_to be_nil
      end

      it 'assigns @sort_presenter' do
        expect(assigns(:sort_presenter)).to be_a(SortPresenter)
      end
    end

    context 'decorators' do
      before do
        get :show, params: { id: book.id }
      end

      it 'decorates cart' do
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates book' do
        expect(assigns(:reviews)).to be_decorated
      end
    end
  end
end
