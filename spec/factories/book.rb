FactoryBot.define do
  factory :book do
    title { FFaker::Book.title }
    price '34.56'
    description { FFaker::Book.description }
    category
    factory :books_with_authors do
      ignore do
        authors_count 2
      end
      after(:create) do |book, evaluator|
        create_list(:author, evaluator.authors_count, books: [book])
      end
    end
  end
end
