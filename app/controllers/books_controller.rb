class BooksController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart
  before_action :sort_params, only: :index

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
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  def sort_params
    @category_id = params[:category]
    @sort_params = params[:sort]
    @popular = params[:popular]
    @books = Book.all.includes(:order_items)
  end
end
