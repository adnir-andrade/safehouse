require 'faker'

FactoryBot.define do
  factory :inventoryitem, class: "InventoriesItem" do
    quantity { Faker::Number.between(from: 1, to: 99) }

    inventory
    item
  end
end
