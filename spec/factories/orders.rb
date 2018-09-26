FactoryBot.define do
  factory :order do
    user
    delivery_type { FFaker::Lorem.word }
    delivery_duration { FFaker::Lorem.word }
    delivery_price { rand(0..20.1).round(2) }

    status

    total { rand(10.1..1000).round(2) }
    factory :order_with_addresses do
      after(:create) do |order|
        create(:billing_address, order: order)
        create(:shipping_address, order: order)
        create(:credit_card, order: order)
      end
    end
  end
end
