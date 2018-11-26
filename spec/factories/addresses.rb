# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    first_name { FFaker::String.from_regexp(NAME) }
    last_name { FFaker::String.from_regexp(NAME) }
    address { FFaker::String.from_regexp(ADDRESS) }
    country { FFaker::String.from_regexp(NAME) }
    city { FFaker::String.from_regexp(NAME) }
    zip { FFaker::String.from_regexp(ZIP) }
    phone { FFaker::PhoneNumber.phone_calling_code }

    factory :billing_address, class: 'BillingAddress' do
    end

    factory :shipping_address, class: 'ShippingAddress' do
    end
  end
end
