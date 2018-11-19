# frozen_string_literal: true

class CartDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_subtotal
    number_to_currency(object.subtotal, precizion: 2)
  end

  def formatted_discount
    number_to_currency(coupon_price, precizion: 2)
  end

  def formatted_total
    number_to_currency(object.total_price, precizion: 2)
  end
end
