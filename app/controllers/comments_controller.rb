# frozen_string_literal: true

class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  respond_to :js

  def create
    @comment = CommentForm.new(comment_params.merge(user_id: current_user.id, book_id: params[:book_id]))
    return respond_with @comment if @comment.save
    render :new
  end

  private

  def comment_params
    params.require(:comment_form).permit(:rating, :title, :text, :book_id)
  end
end
