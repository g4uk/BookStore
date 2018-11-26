# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { create(:cart).decorate }
  let(:user_params) { attributes_for(:user) }
  let(:address_params) { attributes_for(:address) }

  before do
    allow(controller).to receive(:current_user).and_return user
  end

  describe 'GET #login' do
    it 'returns http success' do
      get :login
      expect(response).to have_http_status('200')
    end

    it 'renders login template' do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe 'GET #signup' do
    it 'returns http success' do
      get :signup
      expect(response).to have_http_status('200')
    end

    it 'renders signup template' do
      get :signup
      expect(response).to render_template(:signup)
    end
  end

  describe 'GET #forgot_password' do
    it 'returns http success' do
      get :forgot_password
      expect(response).to have_http_status('200')
    end

    it 'renders forgot_password template' do
      get :forgot_password
      expect(response).to render_template(:forgot_password)
    end
  end

  describe 'GET #change_password' do
    it 'returns http success' do
      get :change_password
      expect(response).to have_http_status('200')
    end

    it 'renders change_password template' do
      get :change_password
      expect(response).to render_template(:change_password)
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user
    end

    it 'returns http success' do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status('200')
    end

    it 'renders edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #update' do
    before do
      sign_in user
    end

    it 'returns http success' do
      post :update, xhr: true, params: { id: user.id, user: user_params }
      expect(response.code).to eql('200')
    end

    context 'with valid attributes' do
      it 'renders update.js' do
        post :update, xhr: true, params: { id: user.id, user: user_params }
        allow(user).to receive(:update_without_password).and_return true
        expect(response).to render_template('users/update')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without user params' do
        expect { post :update, xhr: true, params: { id: user.id } }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'renders edit.js' do
        post :update, xhr: true, params: { id: user.id, user: { email: nil } }
        expect(response).to render_template('users/edit')
      end
    end
  end

  describe 'POST #update_password' do
    before do
      sign_in user
    end

    it 'returns http success' do
      post :update_password, xhr: true, params: { id: user.id, password_form: user_params }
      expect(response.code).to eql('200')
    end

    context 'with valid attributes' do
      it 'renders update_password.js' do
        user_params[:current_password] = user.password
        user_params[:user_id] = user.id
        post :update_password, xhr: true, params: { id: user.id, password_form: user_params }
        allow(user).to receive(:update_with_password).and_return true
        expect(response).to render_template('users/update_password')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without user params' do
        expect { post :update_password, xhr: true, params: { id: user.id } }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'renders edit_password.js' do
        post :update_password, xhr: true, params: { id: user.id, password_form: { password: nil } }
        expect(response).to render_template('users/edit_password')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys user' do
      sign_in user
      expect { delete :destroy, params: { id: user.id } }.to change(User, :count).by(-1)
    end
  end
end
