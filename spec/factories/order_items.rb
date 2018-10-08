FactoryBot.define do
  factory :order_item do
    book
    quantity { rand(1..10) }
    book_name { FFaker::Lorem.sentence }
    book_price { rand(10.1..100).round(2) }
    total { quantity * book_price }
  end
end
