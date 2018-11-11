# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    delivery_type { FFaker::Lorem.word }
    delivery_duration { FFaker::Lorem.word }
    delivery_price { rand(0..20.1).round(2) }
    total { rand(10.1..1000).round(2) }

    transient do
      status { rand(0..8) }
    end

    after(:create) do |order|
      create(:billing_address, addressable: order)
      create(:shipping_address, addressable: order)
      create(:credit_card, order: order)
    end

    transient do
      order_items_count { 4 }
    end

    after(:create) do |order, evaluator|
      create_list(:order_item, evaluator.order_items_count, itemable: order)
    end
  end
end
