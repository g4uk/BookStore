FactoryBot.define do
  factory :status do
    sequence(:name) { |n| "#{FFaker::Lorem.word}#{n}" }
    factory :status_with_orders do
      ignore do
        orders_count 2
      end
      after(:create) do |status, evaluator|
        create_list(:order, evaluator.orders_count, status: status)
      end
    end
  end
end
