require 'ffaker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Status.delete_all
statuses = %w([in_progress] [in_queue] [in_delivery] [delivered] [canceled])
statuses.each { |status| Status.create!(name: status) }

User.delete_all
User.create!(
  email: 'rgbookstore@rgb.ua',
  password: 'Borabora1', password_confirmation: 'Borabora1'
)

Category.delete_all
categories = []
5.times do |index|
  categories << Category.create!(
    name: "#{FFaker::String.from_regexp(NAME)}#{index}"
  )
end

Book.delete_all
categories.each_with_index do |category, index|
  category.books.create!(
    title: "#{FFaker::String.from_regexp(NAME)}#{index}",
    price: '9.99'
  )
end

Author.delete_all
authors = []
5.times do
  authors << Author.create!(
    first_name: FFaker::String.from_regexp(NAME),
    last_name: FFaker::String.from_regexp(NAME)
  )
end
