require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:cart) { FactoryBot.create(:cart) }
  let(:coupon) { FactoryBot.create(:coupon) }

  describe 'GET #show' do
    before do
      allow(Cart).to receive(:find).and_return cart
    end

    it 'returns http success' do
      get :show, params: { id: cart.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders show template' do
      get :show, params: { id: cart.id }
      expect(response).to render_template(:show)
    end

    it 'rescues from RecordNotFound ' do
      get :show, params: { id: 'z' }
      expect(response).to redirect_to(home_index_url)
      expect(flash['notice']).to eql(I18n.t(:no_cart))
    end

    context 'assigns' do
      it 'assigns @cart' do
        get :show, params: { id: cart.id }
        assert_equal cart, assigns(:cart)
      end

      it 'assigns @order_items' do
        get :show, params: { id: cart.id }
        assert_equal order_items, assigns(:order_items)
      end
    end

    context 'decorators' do
      it 'decorates cart' do
        get :show, params: { id: cart.id }
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates book' do
        get :show, params: { id: cart.id }
        expect(assigns(:order_items)).to be_decorated
      end
    end
  end
end
