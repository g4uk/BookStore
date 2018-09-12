class HomesController < ApplicationController
  layout 'main'

  def index
    @books = PopularBooksService.call
    @latest_books = LatestBooksService.call
    respond_to do |format|
      format.html.haml
    end
  end
end
