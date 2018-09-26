FactoryBot.define do
  factory :delivery do
    name { FFaker::Lorem.word }
    duration { FFaker::Lorem.word }
    price { rand(0..20.1).round(2) }
  end
end
