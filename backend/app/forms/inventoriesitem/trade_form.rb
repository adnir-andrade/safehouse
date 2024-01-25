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
    @buyer_items = set_trade_items(buyer, items_offered)
    @seller_items = set_trade_items(seller, items_wanted)
    return false if !has_enough_wanted_items?
    return false if invalid?
    return true
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

  def set_trade_items(survivor, items)
    items_id = []
    items.each { |item|
      items_id << item[:item_id]
    }
    return InventoriesItem.where("inventory_id = #{survivor.inventory_id} AND item_id IN (#{items_id.join(', ')})")
  end

  def has_enough_wanted_items?
    items_wanted.each { |item_wanted|
      seller_items = @seller_items.select { |i| i.item_id == item_wanted[:item_id]}
      items_in_stock = get_quantity(seller_items)

      if item_wanted[:quantity] > items_in_stock
        errors.add(:test, 'Not enough quantity in the inventory of the SELLER to be traded')
        return false
      end
    }

    return true
  end

  def get_quantity(item)
    if item.count > 1
      quantity = 0
      item.each { |stack| quantity += stack[:quantity] }

      return quantity
    end

    return item.first[:quantity]
  end
end