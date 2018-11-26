# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuickSignupsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status('200')
    end

    it 'renders new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, params: { user: user_params }
      expect(response.code).to eql('302')
    end

    context 'with valid attributes' do
      it 'redirects to carts/show' do
        post :create, params: { user: user_params }
        allow(User).to receive(:create).and_return user
        allow(ApplicationMailer).to receive_message_chain(:welcome_email, :deliver).and_return true
        expect(response).to redirect_to("/en/carts/#{session[:cart_id]}")
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without user params' do
        expect { post :create }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'redirects to checkout_login' do
        post :create, params: { user: { email: nil } }
        expect(response).to redirect_to('/en/quick_signups/new')
      end
    end
  end
end
