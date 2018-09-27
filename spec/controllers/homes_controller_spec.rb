require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'decorates cart' do
      get :index
      expect(assigns(:cart)).to be_decorated_with CartDecorator
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'assigns' do
      it 'assigns @books' do
        get :index
        assert_equal PopularBooksService.new.call, assigns(:books)
      end

      it 'assigns @latest_books' do
        get :index
        assert_equal LatestBooksService.call, assigns(:latest_books)
      end
    end
  end
end
