class BooksController < ApplicationController
  layout 'main'

  before_action :sort_params

  # GET /books
  # GET /books.json
  def index
    if @category_id
      books_in_category = @books.where(category_id: @category_id)
      @sorted_books = SortedBooksService.call(sort_params: @sort_params, books: books_in_category)
    else
      @sorted_books = SortedBooksService.call(sort_params: @sort_params, books: @books)
    end
    @categories = CategoryDecorator.decorate_collection(@categories_for_menu)
    @books_quantity = @books.size
    @cart = @cart.decorate
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @book = @book.decorate
    @comment = Comment.new(book_id: @book.id, user_id: current_user.id)
    @order_item = OrderItem.new(book_id: @book.id)
    @reviews = CommentDecorator.decorate_collection(@book.comments.approved)
    @cart = @cart.decorate
  end

  def update
    @book = Book.find(params[:id])
    respond_to do |format|
      if @book.update_attributes(book_params)
        format.js
      else
        @errors = @book.errors.full_messages
        format.js { render :edit }
      end
    end
  end

  private

  def sort_params
    @category_id = params[:category]
    @sort_params = params[:sort]
    @books = Book.all.includes(:order_items)
  end

  def book_params
    params.require(:book).permit(comments_attributes: %i[title text user_id status])
  end
end
