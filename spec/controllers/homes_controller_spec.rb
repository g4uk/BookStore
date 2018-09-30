require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'decorates cart' do
      expect(assigns(:cart)).to be_decorated_with CartDecorator
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    context 'assigns' do
      it 'assigns @books' do
        assert_equal PopularBooksService.new.call, assigns(:books)
      end

      it 'assigns @latest_books' do
        assert_equal LatestBooksService.call, assigns(:latest_books)
      end
    end
  end
end
