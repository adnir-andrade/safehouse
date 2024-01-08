include FactoryBot

items = []
survivors = []

15.times do
  item = Item.create(
    name: Faker::Commerce.product_name,
    value: Faker::Commerce.price,
    description: Faker::Lorem.paragraph
  )

  items << item
end

10.times do
  survivor = Survivor.create(
    name: Faker::Name.name,
    age: Faker::Number.between(from: 15, to: 90),
    gender: Faker::Gender.binary_type,
    is_alive: "Alive"
  )

  inventory = Inventory.create(
    survivor: survivor
  )

  location = Location.create(
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    survivor: survivor
  )

  survivor.update(inventory_id: inventory.id, location_id: location.id)

  survivors << survivor
end

survivors.each do |survivor|
  3.times do
    InventoriesItem.create(
      inventory_id: survivor.inventory_id,
      item_id: items.sample.id,
      quantity: Faker::Number.between(from: 1, to: 99)
    )
  end
end