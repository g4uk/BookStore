require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, status: 5, user: user) }
  let(:cart) { create(:cart) }
  let(:scopes) { OrdersScopesService.call(user) }
  let(:scope_param) { scopes.keys.sample }
  let(:countries_with_codes) { CountriesListService.call }
  let(:deliveries) { Delivery.all.decorate }
  let(:billing_address) { AddressDecorator.decorate(order.billing_address) }
  let(:shipping_address) { AddressDecorator.decorate(order.shipping_address) }
  let(:order_items) { order.order_items.decorate }

  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'assigns' do
      it 'assigns @scopes' do
        get :index
        assert_equal scopes, assigns(:scopes)
      end

      it 'assigns @orders' do
        get :index, params: { scope: scope_param }
        assert_equal scopes[scope_param].decorate, assigns(:orders)
      end

      it 'assigns @scope' do
        get :index, params: { scope: scope_param }
        assert_equal scope_param.to_sym, assigns(:scope)
      end
    end

    context 'decorators' do
      it 'decorates cart' do
        get :index
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates orders' do
        get :index
        expect(assigns(:orders)).to be_decorated_with Draper::CollectionDecorator
      end
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: order.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders show template' do
      get :show, params: { id: order.id }
      expect(response).to render_template(:show)
    end

    context 'assigns' do
      before do
        get :show, params: { id: order.id }
      end

      it 'assigns @order' do
        assert_equal order.decorate, assigns(:order)
      end

      it 'assigns @countries_with_codes' do
        assert_equal countries_with_codes, assigns(:countries_with_codes)
      end

      it 'assigns @deliveries' do
        assert_equal deliveries, assigns(:deliveries)
      end

      it 'assigns @order_items' do
        assert_equal order_items, assigns(:order_items)
      end

      it 'assigns @billing_address' do
        assert_equal billing_address, assigns(:billing_address)
      end

      it 'assigns @shipping_address' do
        assert_equal shipping_address, assigns(:shipping_address)
      end
    end

    context 'decorators' do
      before do
        get :show, params: { id: order.id }
      end

      it 'decorates cart' do
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates order' do
        expect(assigns(:order)).to be_decorated_with OrderDecorator
      end

      it 'decorates deliveries' do
        expect(assigns(:deliveries)).to be_decorated_with Draper::CollectionDecorator
      end

      it 'decorates billing_address' do
        expect(assigns(:billing_address)).to be_decorated_with AddressDecorator
      end

      it 'decorates shipping_address' do
        expect(assigns(:shipping_address)).to be_decorated_with AddressDecorator
      end

      it 'decorates order_items' do
        expect(assigns(:order_items)).to be_decorated_with Draper::CollectionDecorator
      end
    end
  end

  describe 'GET #create' do
    let(:order) { FactoryBot.create(:order, status: 0, user: user) }

    before do
      allow(controller).to receive(:decorate_cart).and_return cart.decorate
      allow(controller).to receive(:set_order).and_return order
      allow(controller).to receive(:ensure_cart_isnt_empty).and_return true
      allow_any_instance_of(CopyInfoToOrderService).to receive(:call).and_return order
    end

    context 'with valid attributes' do
      before do
        post :create
      end

      it 'redirects to checkout' do
        allow(order).to receive(:save).and_return true
        expect(response).to redirect_to('/en/checkouts')
      end

      it 'sets session[:order_id]' do
        assert_equal order.id, session[:order_id]
      end

      it 'changes status' do
        allow(order).to receive(:save).and_return true
        assert_equal 'address', assigns(:order).status
      end
    end
  end
end
