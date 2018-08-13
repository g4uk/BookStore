FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password '1Tt1234678'
    password_confirmation '1Tt1234678'
    factory :user_with_comments do
      ignore do
        comments_count 2
      end
      after(:create) do |user, evaluator|
        create_list(:comment, evaluator.comments_count, user: user)
      end
    end
    factory :user_with_orders do
      ignore do
        orders_count 2
      end
      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user: user)
      end
    end
    factory :user_with_addresses do
      ignore do
        addresses_count 2
      end
      after(:create) do |user, evaluator|
        create_list(:address, evaluator.addresses_count, user: user)
      end
    end
  end
end
