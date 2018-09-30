FactoryBot.define do
  factory :comment do
    title { FFaker::Lorem.sentence }
    text { FFaker::Lorem.paragraph }

    transient do
      rating { rand(0..5) }
      status { rand(0..2) }
    end

    book
    user
  end
end
