# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @sort_presenter = SortPresenter.new(sort_params)
    @books = SortBooksQuery.new(sort_param: params[:sort], category_id: params[:category], page: params[:page]).call
    respond_to :html, :js
  end

  def show
    @sort_presenter = SortPresenter.new(sort_params)
    @book = Book.includes(images: [photo_attachment: :blob]).find(params[:id]).decorate
    @comment_form = CommentForm.new
    @order_item = @book.order_items.new
    @reviews = @book.comments.approved.decorate
  end

  private

  def sort_params
    { sort_param: params[:sort], category_id: params[:category] }
  end
end
