class CategoryDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def books_quantity
    books.size
  end
end
