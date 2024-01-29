class Inventoriesitem::RemoveQuantityForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :quantity

  validates :quantity, presence: true, numericality: { only_integer: true }
  validate :has_enough?

  def inventoryitem=(value)
    if value.is_a?(Integer)
      @inventoryitem = InventoriesItem.find(value)
    end
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

  def has_enough?
    #TODO: Urgently refactor this to catch more errors 
    return if @inventoryitem.quantity - @quantity > 0

    errors.add(:quantity, 'Not enough quantity in the inventory to be removed')
  end
end