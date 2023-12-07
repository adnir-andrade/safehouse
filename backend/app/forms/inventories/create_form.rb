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
    if InventoriesItem.exists?(item_id: item_id, inventory_id: id)
      errors.add(:item_id, 'already exists in the given inventory')
      # TODO: If it exists, add to quantity
      return false
    end

    return false unless valid?

    # binding.pry

    inventory_item = InventoryItem.find_or_initialize_by(item_id: item_id, inventory_id: inventory_id)

    return true
  end
end