class Inventories::CreateForm
  include ActiveModel::Model

  attr_accessor :id, :item_id, :quantity

  validates :id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def add_item
    puts "Trying to add a new item"
    return false if invalid?

    store_item
  end

  private

  def store_item 
    inventory_item = InventoriesItem.find_or_initialize_by(item_id: item_id, inventory_id: id)

    if inventory_item.persisted?
      puts "Trying to add a quantity to inventoryitem"
      inventory_item.quantity += quantity
    else
      inventory_item.quantity = quantity
    end

    if inventory_item.save
      return true
    else
      errors.merge!(item.errors)
      return false
    end
  end
end