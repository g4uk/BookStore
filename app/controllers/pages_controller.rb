class PagesController < ApplicationController
  def home
    @books = PopularBooksService.new.call
    @latest_books = Book.newest.limit(3).decorate
    @cart = @cart.decorate
    respond_to do |format|
      format.html.haml
    end
  end
end
