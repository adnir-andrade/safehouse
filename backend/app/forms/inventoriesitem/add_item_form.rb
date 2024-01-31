class Inventoriesitem::AddItemForm
  include ActiveModel::Model

  attr_accessor :inventory_id, :item_id, :quantity, :inventoryitem

  validates :inventory_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :is_survivor_alive?

  def initialize(attributes = {})
    super
    @inventoryitem = InventoriesItem.find_or_initialize_by(item_id: item_id, inventory_id: inventory_id)
  end

  def quantity=(value)
    @quantity = value.to_i
  end

  def add_quantity
    return false if invalid?

    store_item(@inventoryitem)
  end

  private

  def is_survivor_alive?
    survivor = Survivor.find_by(inventory_id: inventory_id)
    return if survivor[:is_alive]

    errors.add(:survivor, "Survivor is either dead or infected. It's inventory cannot be changed")
  end

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