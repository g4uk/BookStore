# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    transient do
      admin { false }
      customer { true }
    end
  end
end
