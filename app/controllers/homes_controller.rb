class HomesController < ApplicationController
  include CurrentCart
  layout 'main'

  before_action :set_cart

  def index
    @books = Book.all

    respond_to do |format|
      format.html.haml
    end
  end
end
