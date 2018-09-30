FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::String.from_regexp(PASSWORD_REGEXP) }
    password_confirmation { password }

    factory :user_with_comments do
      transient do
        comments_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:comment, evaluator.comments_count, user: user)
      end
    end

    factory :user_with_orders do
      transient do
        orders_count { 4 }
      end

      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user: user)
      end
    end

    factory :user_with_billing_address do
      user_billing_address
    end

    factory :user_with_shipping_address do
      user_shipping_address
    end
  end
end
