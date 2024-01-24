class Inventoriesitem::TradeForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :items_wanted, :items_offered, :buyer, :seller

  validates :items_wanted, presence: true
  validates :items_offered, presence: true

  # validates :quantity, presence: true, numericality: { only_integer: true }
  # validate :has_enough?

  # def quantity=(value)
  #   @quantity = value.to_i.abs
  # end

  def buyer=(id)
    @buyer = Survivor.find(id)
  end

  def seller=(id)
    @seller = Survivor.find(id)
  end

  def start_trade
    set_buyer_items
    set_seller_items
    binding.pry
    return false if invalid?
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
    return if @inventoryitem.quantity - @quantity > 0

    errors.add(:quantity, 'Not enough quantity in the inventory to be removed')
  end

  def set_buyer_items
    items_id = []
    items_offered.each { |item|
      items_id << item[:item_id]
    }
    @buyer_items = InventoriesItem.where("inventory_id = #{@buyer.inventory_id} AND item_id IN (#{items_id.join(', ')})")
  end

  def set_seller_items
    items_id = []
    items_wanted.each { |item|
      items_id << item[:item_id]
    }
    @seller_items = InventoriesItem.where("inventory_id = #{@seller.inventory_id} AND item_id IN (#{items_id.join(', ')})")
  end
end