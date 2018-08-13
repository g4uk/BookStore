FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{FFaker::String.from_regexp(NAME)}#{n}" }
  end
end
