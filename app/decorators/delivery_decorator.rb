class DeliveryDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_price
    number_to_currency(price, precizion: 2)
  end
end
