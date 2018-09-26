FactoryBot.define do
  factory :order_item do
    book
    quantity { rand(0..10) }
    book_name { FFaker::Book.title }
    book_price { rand(10.1..100).round(2) }
    total { quantity * book_price }

    factory :cart_order_item do
      association :cart, factory: :cart
    end

    factory :order_order_item do
      association :order, factory: :order
    end
  end
end
