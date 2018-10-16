require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #index' do
    before do
      get :home
    end

    it 'returns http success' do
      expect(response).to have_http_status('200')
    end

    it 'decorates cart' do
      expect(assigns(:cart)).to be_decorated_with CartDecorator
    end

    it 'renders index template' do
      expect(response).to render_template(:home)
    end

    context 'assigns' do
      it 'assigns @books' do
        assert_equal PopularBooksService.new.call, assigns(:books)
      end

      it 'assigns @latest_books' do
        assert_equal Book.newest.limit(3).decorate, assigns(:latest_books)
      end
    end
  end
end
