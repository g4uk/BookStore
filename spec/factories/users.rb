# frozen_string_literal: true

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

    after(:create) do |user|
      create(:billing_address, addressable: user)
      create(:shipping_address, addressable: user)
    end
  end
end
