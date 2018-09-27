class OrderItemDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_total
    number_to_currency(total, precizion: 2)
  end

  def formatted_book_price
    number_to_currency(book_price, precizion: 2)
  end

  def book_description
    book.description.truncate(150).html_safe unless book.description.blank?
  end

  def book_image(css_class)
    h.image_tag image, class: css_class if image.attached?
  end
end
