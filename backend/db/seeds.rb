
5.times do
  survivor = Survivor.create(
    name: Faker::Name.first_name,
    age: rand(18..99),
    gender: Faker::Gender.binary_type,
    is_alive: Faker::Boolean.boolean,
    is_archived: false
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
end

