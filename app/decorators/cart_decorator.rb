class CartDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_subtotal
    number_to_currency(CartUtilsService.subtotal(order_items), precizion: 2)
  end

  def formatted_discount
    number_to_currency(coupon_price, precizion: 2)
  end

  def formatted_total
    number_to_currency(CartUtilsService.total_price(object), precizion: 2)
  end

  def total_quantity
    CartUtilsService.total_quantity(order_items)
  end
end
