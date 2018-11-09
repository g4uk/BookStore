require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:book) { create(:book) }
  let(:order_item) { cart.order_items.first }
  let(:order_item_params) { attributes_for(:order_item) }

  describe 'POST #create' do
    context 'assigns' do
      it 'assigns @item_presenter' do
        allow(Book).to receive(:find).and_return book
        post :create, xhr: true, params: { order_item: order_item_params }
        expect(assigns(:item_presenter)).to be_a OrderItemPresenter
      end
    end

    context 'with valid attributes' do
      before do
        allow(Book).to receive(:find).and_return book
        post :create, xhr: true, params: { order_item: order_item_params }
      end

      it 'renders create.js' do
        expect(response).to render_template('order_items/create')
      end

      it 'returns http success' do
        expect(response.code).to eql('200')
      end

      it 'creates new item' do
        expect(NewOrderItemService).to receive(:call).and_return :ok
        post :create, xhr: true, params: { order_item: order_item_params }
      end
    end
  end

  describe 'POST #decrement' do
    before do
      allow(CartUtilsService).to receive(:item_total_price).and_return order_item.total
      post :decrement, xhr: true, params: { id: order_item.id }
      allow(order_item).to receive(:save).and_return true
    end

    it 'renders decrement.js' do
      expect(response).to render_template('order_items/decrement')
    end

    it 'returns http success' do
      expect(response.code).to eql('200')
    end

    it 'decrements order_item quantity' do
      expect(assigns(:order_item).quantity).to eql(order_item.quantity - 1)
    end
  end

  describe 'POST #increment' do
    before do
      allow(CartUtilsService).to receive(:item_total_price).and_return order_item.total
      allow(order_item).to receive(:save).and_return order_item
      post :increment, xhr: true, params: { id: order_item.id }
    end

    it 'renders increment.js' do
      expect(response).to render_template('order_items/increment')
    end

    it 'returns http success' do
      allow(order_item).to receive(:save).and_return order_item
      expect(response.code).to eql('200')
    end

    it 'increment order_item quantity' do
      expect(assigns(:order_item).quantity).to eql(order_item.quantity + 1)
    end
  end

  describe 'DELETE #destroy' do
    it 'renders destroy.js' do
      delete :destroy, xhr: true, params: { id: order_item.id }
      expect(response).to render_template('order_items/destroy')
    end

    it 'returns http success' do
      delete :destroy, xhr: true, params: { id: order_item.id }
      expect(response.code).to eql('200')
    end

    it 'destroys order_item' do
      expect { delete :destroy, xhr: true, params: { id: order_item.id } }.to change(cart.order_items, :size).by(-1)
    end
  end
end
