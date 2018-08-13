FactoryBot.define do
  factory :credit_card do
    order
    owner_name { FFaker::String.from_regexp(NAME) }
    expiration_date { '12/20' }
    number { FFaker::String.from_regexp(CREDIT_CARD_NUMBER) }
  end
end
