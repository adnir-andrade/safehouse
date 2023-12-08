require 'faker'

FactoryBot.defined do
  factory :survivor do
    name { Faker::Name.name }
    age
    gender
    is_alive
    longitude
    latitude
    # TODO: Create blueprint here
  end
end