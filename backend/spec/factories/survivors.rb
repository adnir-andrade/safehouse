require 'faker'

FactoryBot.define do
  factory :survivor do
    name { Faker::Name.name }
    age { Faker::Number.between(from: 15, to: 90)}
    gender { Faker::Gender.binary_type }
    is_alive { "Alive" }
    created_at { Time.now }
    updated_at { Time.now }
  end
end