FactoryBot.define do
  factory :address do
    first_name { FFaker::String.from_regexp(NAME) }
    last_name { FFaker::String.from_regexp(NAME) }
    address { FFaker::String.from_regexp(ADDRESS) }
    country { FFaker::String.from_regexp(NAME) }
    city { FFaker::String.from_regexp(NAME) }
    zip { FFaker::String.from_regexp(ZIP) }
    phone { FFaker::PhoneNumber.phone_calling_code }

    factory :billing_address do
      type { 'BillingAddress' }
      association :order, factory: :order

      factory :user_billing_address do
        association :user, factory: :user
      end

      factory :order_billing_address do
        association :order, factory: :order
      end
    end

    factory :shipping_address do
      type { 'ShippingAddress' }
      association :order, factory: :order

      factory :user_shipping_address do
        association :user, factory: :user
      end

      factory :order_shipping_address do
        association :order, factory: :order
      end
    end
  end
end
