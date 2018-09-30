class CommentsController < ApplicationController
  
  before_action :authenticate_user!
  
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        @comment_id = @comment.id
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(rating: params[:rating])
    respond_to do |format|
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:rating, :title, :text, :book_id)
  end
end
