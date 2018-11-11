# frozen_string_literal: true

class BookDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def formatted_authors
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end

  def formatted_price
    number_to_currency(price, precizion: 2)
  end

  def main_image(css_class)
    h.image_tag images.first.photo, class: css_class unless images.blank?
  end

  def short_description(length)
    description.truncate(length).html_safe unless description.blank?
  end
end
