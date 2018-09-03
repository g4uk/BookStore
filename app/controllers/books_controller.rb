class BooksController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart

  # GET /books
  # GET /books.json
  def index
    if !params[:category].blank?
      @books = BookDecorator.decorate_collection(Book.where(category_id: params[:category]))
    elsif !params[:sort].blank?
      @books = BookDecorator.decorate_collection(Book.all.order(params[:sort]))
    else
      @books = BookDecorator.decorate_collection(Book.all)
    end
    @categories = CategoryDecorator.decorate_collection(@categories_for_menu)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end
end
