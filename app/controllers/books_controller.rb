class BooksController < ApplicationController
  def index
    @sort_presenter = SortPresenter.new(sort_params)
    sorted_books = SortBooksQuery.new(sort_param: params[:sort], category_id: params[:category], page: params[:page]).call
    @books = BookDecorator.decorate_collection(sorted_books)
    respond_to :html, :js
  end

  def show
    @sort_presenter = SortPresenter.new(sort_params)
    @book = Book.includes(images: [photo_attachment: :blob]).find(params[:id]).decorate
    @comment = @book.comments.new
    @order_item = @book.order_items.new
    @reviews = CommentDecorator.decorate_collection(@book.comments.approved)
  end

  private

  def sort_params
    { sort_param: params[:sort], category_id: params[:category] }
  end
end
