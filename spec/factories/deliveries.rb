FactoryBot.define do
  factory :delivery do
    name { FFaker::Lorem.word }
    duration { FFaker::Lorem.word }
    price '9.99'
    factory :delivery_with_orders do
      ignore do
        orders_count 2
      end
      after(:create) do |delivery, evaluator|
        create_list(:order, evaluator.orders_count, delivery: delivery)
      end
    end
  end
end
