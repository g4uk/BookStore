require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:sort_conditions) { BooksSortContitionsService.call }
  let(:sort_params) { sort_conditions.sample }
  let(:category_id) { FactoryBot.create(:category).id }
  let(:page) { '1' }
  let(:book) { FactoryBot.create(:book) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
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
      it 'assigns @sort_conditions' do
        get :index
        assert_equal sort_conditions, assigns(:sort_conditions)
      end

      it 'assigns @books_quantity' do
        get :index
        assert_equal Book.all.size, assigns(:books_quantity)
      end

      it 'assigns @books' do
        get :index, params: { sort: sort_params, category: category_id, page: page }
        books = SortedBooksService.new(sort_params: sort_params, category_id: category_id, page: page).call
        assert_equal BookDecorator.decorate_collection(books), assigns(:books)
      end

      it 'assigns @category_id' do
        get :index, params: { category: category_id }
        assert_equal category_id.to_s, assigns(:category_id)
      end

      it 'assigns @category_name' do
        get :index, params: { category: category_id }
        assert_equal Category.find(category_id).name, assigns(:category_name)
      end

      it 'assigns @sort_params' do
        sort_by = sort_params.first
        get :index, params: { sort: sort_by }
        assert_equal sort_by, assigns(:sort_params)
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
      expect(response).to have_http_status(:success)
    end

    it 'renders show template' do
      get :show, params: { id: book.id }
      expect(response).to render_template(:show)
    end

    it 'loads images with book' do
      expect(book.association(:images)).to be_loaded
    end

    context 'assigns' do
      it 'assigns @book' do
        get :show, params: { id: book.id }
        assert_equal book, assigns(:book)
      end

      it 'assigns @category_id' do
        get :show, params: { id: book.id, category: category_id }
        assert_equal category_id.to_s, assigns(:category_id)
      end

      it 'assigns @sort_params' do
        sort_by = sort_params.first
        get :show, params: { id: book.id, sort: sort_by }
        assert_equal sort_by, assigns(:sort_params)
      end

      it 'assigns @comment' do
        get :show, params: { id: book.id }
        expect(assigns(:comment)).not_to be_nil
      end
      
      it 'assigns @order_item' do
        get :show, params: { id: book.id }
        expect(assigns(:comment)).not_to be_nil
      end
    end

    context 'decorators' do
      it 'decorates cart' do
        get :show, params: { id: book.id }
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates book' do
        get :show, params: { id: book.id }
        expect(assigns(:reviews)).to be_decorated
      end
    end
  end
end
