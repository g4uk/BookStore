FactoryBot.define do
  factory :comment do
    title { FFaker::String.from_regexp(COMMENT) }
    text { FFaker::String.from_regexp(COMMENT) }
    rating { rand(0..5) }
    status { rand(0..2) }
    book
    user
  end
end
