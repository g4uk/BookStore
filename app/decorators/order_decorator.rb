class OrderDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_billing_address_name
    "#{billing_address.first_name} #{billing_address.last_name}"
  end

  def formatted_billing_address_city
    "#{billing_address.city} #{billing_address.zip}"
  end

  def formatted_billing_address_phone
    "Phone #{billing_address.phone}"
  end

  def formatted_shipping_address_name
    "#{shipping_address.first_name} #{shipping_address.last_name}"
  end

  def formatted_shipping_address_city
    "#{shipping_address.city} #{shipping_address.zip}"
  end

  def formatted_shipping_address_phone
    "Phone #{shipping_address.phone}"
  end

  def formatted_delivery_name
    "#{delivery.name} #{delivery.price}"
  end

  def formatted_credit_card_number
    "#{'** ' * 3} #{credit_card.number}"
  end

  def formatted_item_total
    number_to_currency(total, precizion: 2)
  end

  def formatted_delivery_price
    number_to_currency(delivery_price.to_i, precizion: 2)
  end

  def formatted_total
    object.total += object.delivery_price.to_i
    number_to_currency(object.total, precizion: 2)
  end
end
