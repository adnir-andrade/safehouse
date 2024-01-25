class Inventoriesitem::AddItemForm
  include ActiveModel::Model

  attr_accessor :inventory_id, :item_id, :quantity, :inventoryitem

  validates :inventory_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def quantity=(value)
    @quantity = value.to_i
  end

  def add_quantity
    return false if invalid?

    inventory_item = InventoriesItem.find_or_initialize_by(item_id: item_id, inventory_id: inventory_id)
    store_item(inventory_item)
  end

  private

  def store_item(inventory_item)
    # TODO: Think about implementing stack size in the future
    if inventory_item.persisted?
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