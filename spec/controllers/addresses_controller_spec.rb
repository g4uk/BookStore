# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  let(:user) { create(:user) }
  let(:address_params) { attributes_for(:address) }

  describe 'POST #create' do
    before do
      sign_in user
      address_params[:addressable_id] = user.id
      address_params[:type] = 'billing'
      address_params[:country] = 'UA'
    end

    it 'returns http success' do
      post :create, xhr: true, params: { address_form: address_params }
      expect(response.code).to eql('200')
    end

    context 'with valid attributes' do
      it 'renders update_addresses.js' do
        post :create, xhr: true, params: { address_form: address_params }
        allow(user).to receive_message_chain(:billing_address, :update).and_return true
        expect(response).to render_template('addresses/update_addresses')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without user params' do
        expect { post :create, xhr: true }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'renders edit_addresses.js' do
        address_params[:address] = nil
        post :create, xhr: true, params: { address_form: address_params }
        expect(response).to render_template('addresses/edit_addresses')
      end
    end
  end
end
