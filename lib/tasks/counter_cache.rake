# frozen_string_literal: true

desc 'Counter cache for category has many books'

task book_counter: :environment do
  Category.reset_column_information
  Category.find_each do |category|
    Category.reset_counters category.id, :books
  end
end

task comment_counter: :environment do
  Book.reset_column_information
  Book.find_each do |book|
    Book.reset_counters book.id, :comments
  end
end
