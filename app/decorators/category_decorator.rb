class CategoryDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def books_qantity
    books.count
  end
end
