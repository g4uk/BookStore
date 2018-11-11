# frozen_string_literal: true

class OrderItemPresenter < BasePresenter
  DEFAULT_QUANTITY = 1

  attr_reader :book_id, :quantity

  def initialize(book_id:, item_params:)
    @book_id = book_id ? book_id : item_params[:book_id]
    @quantity = item_params ? item_params[:quantity] : DEFAULT_QUANTITY
  end
end
