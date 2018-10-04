require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:order_params) { attributes_for(:order) }
  let(:cart) { create(:cart).decorate }
  let(:countries_with_codes) { CountriesListService.call }
  let(:delivery) { create(:delivery).decorate }
  let(:billing_address) { AddressDecorator.decorate(order.billing_address) }
  let(:shipping_address) { AddressDecorator.decorate(order.shipping_address) }
  let(:order_items) { order.order_items.decorate }
  let(:credit_card) { create(:credit_card) }
  let(:steps) { %i[address delivery payment confirm complete] }

  before do
    sign_in user
    allow(Order).to receive(:find).and_return(order)
    allow(Order).to receive_message_chain(:includes, :find).and_return order
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    before do
      get :show, params: { order_id: order.id, id: :address }
    end

    context 'assigns' do
      it 'assignes @order' do
        expect(assigns(:order)).to be_a(Order)
      end

      it 'assignes @countries_with_codes' do
        expect(assigns(:countries_with_codes)).to eql(countries_with_codes)
      end

      it 'assignes @billing_address' do
        expect(assigns(:billing_address)).to eql(billing_address)
      end

      it 'assignes @shipping_address' do
        expect(assigns(:shipping_address)).to eql(shipping_address)
      end
    end

    context 'decorators' do
      it 'decorates @billing_address' do
        expect(assigns(:billing_address)).to be_decorated_with AddressDecorator
      end

      it 'decorates @deliveries' do
        expect(assigns(:deliveries)).to be_decorated_with Draper::CollectionDecorator
      end

      it 'decorates @order_items' do
        expect(assigns(:order_items)).to be_decorated_with Draper::CollectionDecorator
      end
    end

    describe 'steps' do
      it 'returns http success on every step' do
        steps.each do |step|
          get :show, params: { order_id: order.id, id: step }
          expect(response).to have_http_status('200')
        end
      end

      it 'renders template for the current step' do
        steps.each do |step|
          get :show, params: { order_id: order.id, id: step }
          expect(response).to render_template step
        end
      end
    end
  end

  describe 'PUT #update' do
    before do
      order.status = :payment
      order_params[:credit_card_attributes] = { number: credit_card.number }
      allow(order).to receive(:update).and_return true
      allow(order).to receive(:save).and_return true
      allow(Delivery).to receive(:find).and_return delivery
    end

    context 'already paid' do
      let(:steps) { %i[address delivery payment confirm] }

      it 'jumps to :confirm' do
        steps.each do |step|
          put :update, params: { order_id: order.id, id: step, order: order_params }
          expect(response).to redirect_to checkout_path(id: :confirm)
        end
      end
    end

    context 'not paid yet' do
      it 'fills address info' do
        expect(FillAddressesService).to receive(:call).and_return true
        put :update, params: { order_id: order.id, id: :address, order: order_params }
      end

      it 'fills delivery info' do
        expect(UpdateOrdersDeliveryInfoService).to receive(:call).and_return true
        put :update, params: { order_id: order.id, id: :delivery, order: order_params }
      end

      it 'makes payment' do
        expect(PaymentService).to receive(:call).and_return order
        put :update, params: { order_id: order.id, id: :payment, order: order_params }
      end
    end

    context 'order may be confirmed' do
      it 'confirms an order' do
        expect(ApplicationMailer).to receive_message_chain(:order_email, :deliver)
        put :update, params: { order_id: order.id, id: :confirm, order: order_params }
        expect(order.in_queue?).to eql true
      end
    end
  end
end
