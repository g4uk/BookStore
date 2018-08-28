class BooksController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart

  # GET /books
  # GET /books.json
  def index
    @books = BookDecorator.decorate_collection(Book.all)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end
end
