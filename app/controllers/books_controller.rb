class BooksController < ApplicationController
  layout 'main'

  before_action :decorate_cart

  respond_to :html, :js, only: [:index]

  # GET /books
  # GET /books.json
  def index
    sort_params
    sorted_books = SortedBooksService.new(sort_params: @sort_params, category_id: @category_id, page: params[:page]).call
    @books = BookDecorator.decorate_collection(sorted_books)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.includes(images: [photo_attachment: :blob]).find(params[:id]).decorate
    @comment = Comment.new(book_id: @book.id, user_id: current_user.id)
    @order_item = OrderItem.new(book_id: @book.id)
    @reviews = CommentDecorator.decorate_collection(@book.comments.approved)
    @cart = @cart.decorate
  end

  private

  def decorate_cart
    @cart = @cart.decorate
  end

  def sort_params
    @sort_params = params[:sort] ? params[:sort] : :all
    @category_id = params[:category]
    @category_name = @category_id ? Category.find(@category_id).name : :all
    @sort_conditions = BooksSortContitionsService.call
    @books_quantity = Book.all.size
  end

  def book_params
    params.require(:book).permit(comments_attributes: %i[title text user_id status])
  end
end
