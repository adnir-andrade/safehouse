class Inventoriesitem::RemoveQuantityForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :quantity

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :inventoryitem, presence: true
  validate :has_enough?
  validate :is_survivor_alive?

  def inventoryitem=(value)
    @inventoryitem = value.is_a?(Integer) ? InventoriesItem.find(value) : value
  end

  def quantity=(value)
    @quantity = value.to_i.abs
  end

  def remove_quantity
    puts "Trying to remove quantity from an item"
    return false if invalid?

    update_quantity(@inventoryitem)
  end

  private

  def update_quantity(inventory_item)
    inventory_item.quantity -= quantity
    if inventory_item.save
      return true
    else
      errors.merge!(item.errors)
      return false
    end
  end

  def is_survivor_alive?
    survivor = Survivor.find_by(inventory_id: inventoryitem[:inventory_id])
    return if survivor[:is_alive]

    errors.add(:survivor, "Survivor is either dead or infected. It's inventory cannot be changed")
  end

  def has_enough?
    return if @inventoryitem.quantity - @quantity > 0

    errors.add(:quantity, 'Not enough quantity in the inventory to be removed')
  end
end