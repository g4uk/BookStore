require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:book) { FactoryBot.create(:book) }
  let(:comment) { FactoryBot.build_stubbed(:comment, status: 0) }
  let(:comment_params) { FactoryBot.attributes_for(:comment) }

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
    end

    context 'with forbidden attributes' do
      it 'generates ParameterMissing error without comment params' do
        expect { post :create, xhr: true }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'with invalid attributes' do
      before do
        post :create, xhr: true, params: { comment: { book_id: nil } }
      end

      it 'renders new.js' do
        allow(comment).to receive(:save).and_return false
        expect(response.code).to eql('200')
        expect(response).to render_template('comments/new')
      end
    end
  end
end
