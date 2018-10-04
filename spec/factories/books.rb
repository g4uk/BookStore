FactoryBot.define do
  factory :book do
    title { FFaker::Lorem.word + FFaker::String.from_regexp(NAME) }
    price { rand(10.1..100).round(2) }
    description { FFaker::Book.description }
    category
    publishing_year { Date.today.year }
    dimensions { FFaker::Lorem.words }
    materials { FFaker::Lorem.words }

    factory :books_with_authors do
      transient do
        authors_count { 2 }
      end

      after(:create) do |book, evaluator|
        create_list(:author, evaluator.authors_count, books: [book])
      end
    end

    factory :book_with_comments do
      transient do
        comments_count { 2 }
      end

      after(:create) do |book, evaluator|
        create_list(:comment, evaluator.comments_count, book: book)
      end
    end

    factory :book_with_images do
      transient do
        images_count { 4 }
      end

      after(:create) do |book, evaluator|
        create_list(:image, evaluator.images_count, books: book)
      end
    end
  end
end
