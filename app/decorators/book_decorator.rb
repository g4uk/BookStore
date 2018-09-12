class BookDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def formatted_authors
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end

  def price_to_dollar(amount)
    number_to_currency(amount, unit: '$')
  end

  def quantity
    count
  end

  def main_image
    images.first
  end
end
