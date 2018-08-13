FactoryBot.define do
  factory :comment do
    title { FFaker::String.from_regexp(NAME) }
    text { FFaker::String.from_regexp(NAME) }
    status { FFaker::Boolean.maybe }
    book
    user
  end
end
