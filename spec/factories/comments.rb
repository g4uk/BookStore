FactoryBot.define do
  factory :comment do
    title { FFaker::Lorem.sentence }
    text { FFaker::Lorem.paragraph }
    rating { rand(1..5) }
    status { :approved }
    book
    user
  end
end
