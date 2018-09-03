class HomesController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart

  def index
    @books = PopularBooksService.call
    @latest_books = LatestBooksService.call
    respond_to do |format|
      format.html.haml
    end
  end
end
