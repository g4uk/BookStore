require 'rails_helper'

RSpec.describe OrderDecorator do
  include ActionView::Helpers::NumberHelper

  let(:order) { create(:order).decorate }
  let(:delivery) { create(:delivery) }

  it 'formats delivery_name' do
    order.delivery = delivery
    delivery_name = "#{order.delivery_type} #{number_to_currency(order.delivery_price, precizion: 2)}"
    expect(order.formatted_delivery_name).to eql(delivery_name)
  end

  it 'formats credit_card_number' do
    credit_card_number = "#{'** ' * 3} #{order.credit_card.number}"
    expect(order.formatted_credit_card_number).to eql(credit_card_number)
  end

  it 'formats item_total' do
    total = number_to_currency(order.total, precizion: 2)
    expect(order.formatted_item_total).to eql(total)
  end

  it 'formats delivery_price' do
    order.delivery = delivery
    delivery_price = number_to_currency(order.delivery_price, precizion: 2)
    expect(order.formatted_delivery_price).to eql(delivery_price)
  end

  it 'formats total' do
    total = order.total + order.delivery_price
    total = number_to_currency(total, precizion: 2)
    expect(order.formatted_total).to eql(total)
  end

  it 'formats date' do
    date = order.created_at.strftime('%B %d, %Y')
    expect(order.formatted_date).to eql(date)
  end

  it 'formats updated_at' do
    date = order.created_at.strftime('%F')
    expect(order.formatted_updated_at).to eql(date)
  end

  it 'formats status' do
    css_class = order.delivered? ? 'text-success' : 'in-grey-900'
    tag = h.content_tag(:span, h.t(order.status), class: "font-16 #{css_class} fw-300")
    expect(order.formatted_status).to eql(tag)
  end
end
