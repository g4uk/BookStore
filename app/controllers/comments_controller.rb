class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def create
    @comment = CommentForm.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js { render :new }
      end
    end
  end

  private

  def comment_params
    params.require(:comment_form).permit(:rating, :title, :text, :book_id)
  end
end
