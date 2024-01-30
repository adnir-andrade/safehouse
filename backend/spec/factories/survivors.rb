require 'faker'

FactoryBot.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.between(from: 15, to: 90)}
    gender { Faker::Gender.binary_type }
    is_alive { "Alive" }
    infection_claim_count { Faker::Number.between(from: 0, to: 4) }
    wallet { Faker::Number.between(from: 0, to: 200) }
    created_at { Time.now }
    updated_at { Time.now }
  end
end