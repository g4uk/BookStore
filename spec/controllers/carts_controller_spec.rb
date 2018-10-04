require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:order_items) { OrderItemDecorator.decorate_collection(cart.order_items.order(:created_at)) }
  let(:coupon) { create(:coupon) }

  describe 'GET #show' do
    before do
      allow(Cart).to receive(:find).and_return cart
      get :show, params: { id: cart.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders show template' do
      expect(response).to render_template(:show)
    end

    context 'assigns' do
      it 'assigns @cart' do
        assert_equal cart, assigns(:cart)
      end

      it 'assigns @order_items' do
        assert_equal order_items, assigns(:order_items)
      end
    end

    context 'decorators' do
      it 'decorates cart' do
        expect(assigns(:cart)).to be_decorated_with CartDecorator
      end

      it 'decorates book' do
        expect(assigns(:order_items)).to be_decorated
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before do
        put :update, xhr: true, params: { id: cart.id, cart: { coupon_code: coupon.code} }
        allow(Coupon).to receive_message_chain(:where, :first).and_return coupon
      end

      it 'assigns coupon' do
        assert_equal coupon, assigns(:coupon)
      end

      it 'renders update.js' do
        expect(response.code).to eql('200')
        expect(response).to render_template('carts/update')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without cart params' do
        expect { put :update, xhr: true, params: { id: cart.id } }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      before do
        put :update, xhr: true, params: { id: cart.id, cart: { coupon_code: nil } }
        allow(Coupon).to receive_message_chain(:where, :first).and_return nil
      end

      it 'renders edit.js' do
        expect(response.code).to eql('200')
        expect(response).to render_template('carts/edit')
      end
    end
  end
end
