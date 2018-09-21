class BooksController < ApplicationController
  layout 'main'

  before_action :sort_params, only: :index
  before_action :decorate_cart

  # GET /books
  # GET /books.json
  def index
    @sorted_books = SortedBooksService.call(sort_params: @sort_params, category_id: @category_id)
    @categories = CategoryDecorator.decorate_collection(@categories_for_menu)
    @books_quantity = @sorted_books.size
    
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
    @sort_params = params[:sort]
    @category_id = params[:category]
  end

  def book_params
    params.require(:book).permit(comments_attributes: %i[title text user_id status])
  end
end
