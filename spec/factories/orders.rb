FactoryBot.define do
  factory :order do
    user
    delivery_type { FFaker::Lorem.word }
    delivery_price '134.56'
    coupon_code { FFaker::String.from_regexp(COUPON) }
    status
    delivery
    total '134.56'
    after(:create) do |order|
      create(:billing_address, order: order)
      create(:credit_card, order: order)
    end
  end
end
