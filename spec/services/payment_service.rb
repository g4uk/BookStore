# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentService do
  let(:order) { create(:order) }
  let(:cart) { create(:cart) }
  let(:credit_card_number) { create(:credit_card).number.last(4) }
  let(:order_params) { attributes_for(:order) }

  before do
    order_params[:credit_card_attributes] = { number: credit_card_number }
  end

  context 'order may not fill payment' do
    it 'adds credit_card to order' do
      PaymentService.new(order: order, order_params: order_params, cart: cart).call
      expect(order.credit_card.number).to eql(credit_card_number)
    end
  end

  context 'order may fill payment' do
    before do
      order.status = 'in_progress'
    end
    it 'changes order status to payment' do
      PaymentService.new(order: order, order_params: order_params, cart: cart).call
      expect(order.payment?).to eql true
    end

    it 'destroys cart after payment' do
      cart = create(:cart)
      expect { PaymentService.new(order: order, order_params: order_params, cart: cart).call }.to change(Cart, :count).by(-1)
    end
  end
end
