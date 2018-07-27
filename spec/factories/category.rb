FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{FFaker::Book.genre}#{n}" }
  end
end
