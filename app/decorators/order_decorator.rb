class OrderDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  decorates_association :order_items

  def formatted_delivery_name
    "#{delivery_type} #{formatted_delivery_price}"
  end

  def formatted_credit_card_number
    "#{'** ' * 3} #{credit_card.number}"
  end

  def formatted_item_total
    number_to_currency(total, precizion: 2)
  end

  def formatted_delivery_price
    number_to_currency(delivery_price, precizion: 2)
  end

  def formatted_total
    total_sum = delivery_price.present? ? (total + delivery_price) : total
    number_to_currency(total_sum, precizion: 2)
  end

  def formatted_date
    created_at.strftime('%B %d, %Y')
  end

  def formatted_updated_at
    created_at.strftime('%F')
  end

  def formatted_status
    css_class = object.delivered? ? 'text-success' : 'in-grey-900'
    h.content_tag(:span, h.t(status), class: "font-16 #{css_class} fw-300")
  end
end
