FactoryBot.define do
  factory :order_item do
    book
    cart
    order
    quantity 1
    book_name { FFaker::Book.title }
    book_price '34.56'
  end
end
