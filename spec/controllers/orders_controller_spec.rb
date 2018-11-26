# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  ORDERS_SCOPES = %i[sorted_paid in_progress in_delivery delivered canceled].freeze

  let(:user) { create(:user) }
  let(:order) { create(:order, status: 5, user: user) }
  let(:cart) { create(:cart) }
  let(:scopes) { ORDERS_SCOPES }
  let(:scope_param) { scopes.sample }
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
      expect(response).to have_http_status('200')
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
      expect(response).to have_http_status('200')
    end

    it 'renders show template' do
      get :show, params: { id: order.id }
      expect(response).to render_template(:show)
    end

    context 'assigns' do
      before do
        get :show, params: { id: order.id }
      end

      it 'assigns @order_presenter' do
        expect(assigns(:order_presenter)).to be_a OrderPresenter
      end

      it 'assigns @order' do
        assert_equal order.decorate, assigns(:order)
      end

      it 'assigns @user' do
        assert_equal user, assigns(:user)
      end
    end

    context 'decorators' do
      before do
        get :show, params: { id: order.id }
      end

      it 'decorates cart' do
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end
    end
  end

  describe 'GET #create' do
    let(:order) { FactoryBot.create(:order, status: 0, user: user) }

    context 'with valid attributes' do
      before do
        allow(CopyInfoToOrderService).to receive_message_chain(:new, :call).and_return order
        post :create
      end

      it 'creates order' do
        expect(CreateOrderService).to receive_message_chain(:call).and_return :ok
        post :create
      end

      it 'redirects to checkout' do
        expect(response).to redirect_to('/en/checkouts')
      end

      it 'sets session[:order_id]' do
        assert_equal order.id, session[:order_id]
      end

      it 'changes status' do
        assert_equal 'address', assigns(:order).status
      end
    end
  end
end
