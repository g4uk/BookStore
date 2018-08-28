FactoryBot.define do
  factory :book do
    title { FFaker::Book.title }
    price '34.56'
    description { FFaker::Book.description }
    category
    publishing_year 2017
    dimensions { FFaker::Lorem.words }
    materials { FFaker::Lorem.words }
    factory :books_with_authors do
      ignore do
        authors_count 2
      end
      after(:create) do |book, evaluator|
        create_list(:author, evaluator.authors_count, books: [book])
      end
    end
    factory :books_with_comments do
      ignore do
        comments_count 2
      end
      after(:create) do |book, evaluator|
        create_list(:comment, evaluator.comments_count, book: book)
      end
    end
  end
end
