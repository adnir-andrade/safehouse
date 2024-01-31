require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    value { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
  end
end