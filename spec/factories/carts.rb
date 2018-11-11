# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    transient do
      order_items_count { 4 }
    end

    after(:create) do |cart, evaluator|
      create_list(:order_item, evaluator.order_items_count, itemable: cart)
    end
  end
end
