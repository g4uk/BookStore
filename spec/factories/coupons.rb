FactoryBot.define do
  factory :coupon do
    code { FFaker::String.from_regexp(COUPON) }
    discount { rand(1..10) }
  end
end
