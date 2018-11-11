# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:comment) { create(:comment, status: 0, user_id: user.id) }
  let(:comment_params) { attributes_for(:comment) }

  describe 'POST #create' do
    before do
      sign_in user
    end

    context 'with valid attributes' do
      it 'creates a new Comment' do
        expect { post :create, xhr: true, params: { comment_form: comment_params, book_id: book.id } }.to change(Comment, :count).by(1)
      end

      it 'renders create.js' do
        post :create, xhr: true, params: { comment_form: comment_params, book_id: book.id }
        allow(comment).to receive(:save).and_return true
        expect(response.code).to eql('200')
        expect(response).to render_template('comments/create')
      end

      it 'returns http success' do
        post :create, xhr: true, params: { comment_form: comment_params, book_id: book.id }
        expect(response.code).to eql('200')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without comment params' do
        expect { post :create, xhr: true, params: { book_id: book.id } }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'renders new.js' do
        post :create, xhr: true, params: { comment_form: { title: nil }, book_id: book.id }
        allow(comment).to receive(:save).and_return false
        expect(response.code).to eql('200')
        expect(response).to render_template('comments/new')
      end
    end
  end
end
