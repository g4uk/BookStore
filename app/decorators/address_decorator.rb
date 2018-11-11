# frozen_string_literal: true

class AddressDecorator < Draper::Decorator
  delegate_all

  def formatted_name
    "#{first_name} #{last_name}"
  end

  def formatted_city
    "#{city} #{zip}"
  end

  def formatted_phone
    "Phone #{address.phone}"
  end

  def formatted_address
    address.address
  end
end
