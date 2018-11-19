# frozen_string_literal: true

require 'ffaker'

Comment.delete_all
OrderItem.delete_all
Order.delete_all
User.delete_all
Category.delete_all
Author.delete_all
Book.delete_all
Coupon.delete_all
Delivery.delete_all
Address.delete_all
CreditCard.delete_all

user = User.create!(
  email: 'rgbookstore@rgb.ua',
  password: 'Borabora1', password_confirmation: 'Borabora1'
)
user.add_role :admin

categories = []
5.times do |_index|
  categories << Category.create!(
    name: FFaker::String.from_regexp(NAME)
  )
end

author = Author.create!(
  first_name: FFaker::String.from_regexp(NAME),
  last_name: FFaker::String.from_regexp(NAME)
)

books = []
categories.each_with_index do |category, _index|
  4.times do
    books << Book.create!(
      category: category,
      title: FFaker::Lorem.sentence,
      price: rand(10.1..100).round(2),
      description: FFaker::Lorem.paragraphs,
      publishing_year: Date.today.year,
      dimensions: FFaker::Lorem.words,
      materials: FFaker::Lorem.words
    )
  end
end
books.each { |book| book.authors << author }

books.each do |book|
  book.comments.create!(
    user: user,
    title: FFaker::Lorem.sentence,
    text: FFaker::Lorem.paragraph,
    rating: rand(0..5),
    status: 'approved'
  )
end

Coupon.create!(
  code: FFaker::String.from_regexp(COUPON),
  discount: rand(1..10)
)

deliveries = []
3.times do
  deliveries << Delivery.create!(
    name: FFaker::Lorem.word,
    duration: FFaker::Lorem.word,
    price: rand(0..20.1).round(2)
  )
end

billing_address = Address.new(
  first_name: FFaker::String.from_regexp(NAME),
  last_name: FFaker::String.from_regexp(NAME),
  address: FFaker::String.from_regexp(ADDRESS),
  country: FFaker::String.from_regexp(NAME),
  city: FFaker::String.from_regexp(NAME),
  zip: FFaker::String.from_regexp(ZIP),
  phone: FFaker::PhoneNumber.phone_calling_code,
  type: 'BillingAddress'
)

shipping_address = Address.new(
  first_name: FFaker::String.from_regexp(NAME),
  last_name: FFaker::String.from_regexp(NAME),
  address: FFaker::String.from_regexp(ADDRESS),
  country: FFaker::String.from_regexp(NAME),
  city: FFaker::String.from_regexp(NAME),
  zip: FFaker::String.from_regexp(ZIP),
  phone: FFaker::PhoneNumber.phone_calling_code,
  type: 'ShippingAddress'
)

delivery = deliveries.first
order1 = Order.create!(
  user: user,
  delivery_type: delivery.name,
  delivery_duration: delivery.duration,
  delivery_price: delivery.price,
  total: rand(10.1..1000).round(2),
  status: 'delivered',
  billing_address: billing_address,
  shipping_address: shipping_address
)

delivery = deliveries.last
order2 = Order.create!(
  user: user,
  delivery_type: delivery.name,
  delivery_duration: delivery.duration,
  delivery_price: delivery.price,
  total: rand(10.1..1000).round(2),
  status: 'in_queue',
  billing_address: billing_address,
  shipping_address: shipping_address
)

CreditCard.create!(
  number: FFaker::String.from_regexp(CREDIT_CARD_NUMBER),
  order: order1
)

CreditCard.create!(
  number: FFaker::String.from_regexp(CREDIT_CARD_NUMBER),
  order: order2
)

order_items = []
quantity = rand(1..10)
books.each do |book|
  order_items << OrderItem.new(
    book: book,
    quantity: quantity,
    book_name: book.title,
    book_price: book.price,
    total: book.price * quantity
  )
end

order1.order_items << order_items
order1.save
order2.order_items << order_items
order2.save
