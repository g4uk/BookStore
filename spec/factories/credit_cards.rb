FactoryBot.define do
  factory :credit_card do
    number { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
    order
  end
end
