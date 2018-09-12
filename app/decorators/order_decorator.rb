class OrderDecorator < Draper::Decorator
  delegate_all

  def formatted_billing_address_name
    "#{object.billing_address.first_name} #{object.billing_address.last_name}"
  end

  def formatted_billing_address_city
    "#{object.billing_address.country} #{object.billing_address.city} #{object.billing_address.zip}"
  end

  def formatted_billing_address_phone
    "Phone #{object.billing_address.phone}"
  end

  def formatted_shipping_address_name
    "#{object.shipping_address.first_name} #{object.shipping_address.last_name}"
  end

  def formatted_shipping_address_city
    "#{object.shipping_address.country} #{object.shipping_address.city} #{object.shipping_address.zip}"
  end

  def formatted_shipping_address_phone
    "Phone #{object.shipping_address.phone}"
  end

  def formatted_delivery_name
    "#{object.delivery.name} #{object.delivery.price}"
  end

  def formatted_credit_card_number
    "** *3 #{object.credit_card.number}"
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
