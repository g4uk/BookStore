FactoryBot.define do
  factory :role do
    transient do
      admin { false }
      customer { true }
    end
  end
end
