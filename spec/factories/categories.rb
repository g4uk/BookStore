FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{FFaker::String.from_regexp(NAME)}#{n}" }

    factory :category_with_books do
      transient do
        books_count { 5 }
      end

      after(:create) do |category, evaluator|
        create_list(:book, evaluator.books_count, category: category)
      end
    end
  end
end
