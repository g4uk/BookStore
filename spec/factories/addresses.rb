FactoryBot.define do
  factory :billing_address do
    first_name { FFaker::String.from_regexp(NAME) }
    last_name { FFaker::String.from_regexp(NAME) }
    address { FFaker::String.from_regexp(ADDRESS) }
    country { FFaker::String.from_regexp(NAME) }
    city { FFaker::String.from_regexp(NAME) }
    zip { FFaker::String.from_regexp(ZIP) }
    phone '+380999999999'
    user
    order
  end
end
