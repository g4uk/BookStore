FactoryBot.define do
  factory :coupon do
    code { FFaker::String.from_regexp(COUPON) }
    discount 1
  end
end
