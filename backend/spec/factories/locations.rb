require 'faker'

FactoryBot.define do
  factory :location do
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }
  end
end