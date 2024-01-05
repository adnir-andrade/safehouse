class Inventoriesitem::ItemManagementForm
  include ActiveModel::Model

  attr_accessor :inventory_id, :item_id, :quantity, :inventoryitem

  validates :inventory_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def add_quantity
    puts "Trying to add a new item"
    return false if invalid?

    inventory_item = InventoriesItem.find_or_initialize_by(item_id: item_id, inventory_id: inventory_id)
    store_item(inventory_item)
  end

  def remove_quantity
    return false if invalid?

    if @inventoryitem.quantity - @quantity > 0
      @quantity *= -1
      store_item(@inventoryitem)
    else
      errors.add(:quantity, 'Not enough quantity in the inventory to be removed')
      return false
    end
  end

  private

  def store_item(inventory_item)
    if inventory_item.persisted?
      inventory_item.quantity += quantity.to_i
    else
      inventory_item.quantity = quantity.to_i
    end

    if inventory_item.save
      return true
    else
      errors.merge!(item.errors)
      return false
    end
  end
end