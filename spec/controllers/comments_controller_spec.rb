require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:comment) { build_stubbed(:comment, status: 0) }
  let(:comment_params) { attributes_for(:comment) }

  describe 'POST #create' do
    before do
      sign_in user
    end

    context 'with valid attributes' do
      before do
        comment.user_id = user.id
        comment_params[:book_id] = book.id
      end

      it 'creates a new Comment' do
        expect { post :create, xhr: true, params: { comment: comment_params } }.to change(Comment, :count).by(1)
      end

      it 'renders create.js' do
        post :create, xhr: true, params: { comment: comment_params }
        allow(comment).to receive(:save).and_return true
        expect(response.code).to eql('200')
        expect(response).to render_template('comments/create')
      end

      it 'returns http success' do
        post :create, xhr: true, params: { comment: comment_params }
        expect(response.code).to eql('200')
      end
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without comment params' do
        expect { post :create, xhr: true }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      it 'renders new.js' do
        post :create, xhr: true, params: { comment: { book_id: nil } }
        allow(comment).to receive(:save).and_return false
        expect(response.code).to eql('200')
        expect(response).to render_template('comments/new')
      end
    end
  end

  describe 'POST #update' do
    before do
      sign_in user
      allow(Comment).to receive(:find).and_return comment
      allow(comment).to receive(:update).and_return true
      post :update, xhr: true, params: { id: comment.id, rating: comment.rating }
    end

    it 'renders update.js' do
      expect(response).to render_template('comments/update')
    end

    it 'returns http success' do
      expect(response.code).to eql('200')
    end

    it 'assigns @comment' do
      assert_equal comment, assigns(:comment)
    end
  end
end
