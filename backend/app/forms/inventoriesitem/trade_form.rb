class Inventoriesitem::TradeForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :vendor_offer, :buyer_offer, :buyer, :vendor

  validates :vendor_offer, presence: true
  validates :buyer_offer, presence: true

  def buyer=(id)
    @buyer = Survivor.find(id)
  end

  def vendor=(id)
    @vendor = Survivor.find(id)
  end

  def initialize(attributes = {})
    super
    @buyer_items = set_trade_items(buyer, buyer_offer)
    @buyer_total_value = calculate_total(buyer_offer)
    @vendor_items = set_trade_items(vendor, vendor_offer)
    @vendor_total_value = calculate_total(vendor_offer)
  end

  def start_trade
    return false if !has_enough_wanted_items?
    return false if !has_enough_money?
    return false if invalid?
    trade
    return true
  end

  private

  def trade
    InventoriesItem.transaction do
      puts "GETTING ITEMS FROM VENDOR TO BUYER"
      transfer_items(vendor_offer, @buyer, @vendor_items)

      puts "GETTING ITEMS FROM BUYER TO VENDOR"
      transfer_items(buyer_offer, @vendor, @buyer_items)
    end

    return true
  end

  def set_trade_items(survivor, items)
    items_id = []
    items.each { |item|
      items_id << item[:item_id]
    }
    return InventoriesItem.where("inventory_id = #{survivor.inventory_id} AND item_id IN (#{items_id.join(", ")})")
  end

  # TODO: Apparently, gotta check from the fucking buyer as well
  def has_enough_wanted_items?
    vendor_offer.each { |item_wanted|
      vendor_items = @vendor_items.select { |i| i.item_id == item_wanted[:item_id] }
      items_in_stock = get_quantity(vendor_items)

      if item_wanted[:quantity] > items_in_stock
        # Alternatively: Would be a good idea to set the desired quantity to the max. quantity available in this case.
        # But I think, for now, this is good.
        errors.add(:quantity, "Not enough quantity in the inventory of the SELLER to be traded")
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

  def calculate_total(items)
    total = 0
    items.each { |item|
      item_entry = Item.find_by id: item[:item_id]
      total += item[:quantity] * item_entry[:value]
    }

    return total
  end

  def has_enough_money?
    if @buyer_total_value < @vendor_total_value
      errors.add(:money, "The buyer doesn't have enough money to proceed with this trade")
      return false
    end

    return true
  end

  def transfer_items(items, receiver, sender_items)
    add_item_forms = []
    remove_quantity_forms = []
    items.each { |item|
      # TODO: Consider changing this part to deal with stack size
      add_item_forms << Inventoriesitem::AddItemForm.new(
        { inventory_id: receiver[:inventory_id],
          item_id: item[:item_id],
          quantity: item[:quantity] }
      )
      sender_item = sender_items.select { |i| i.item_id == item[:item_id] }
      remove_quantity_forms << Inventoriesitem::RemoveQuantityForm.new(
        { inventoryitem: sender_item.first,
          quantity: item[:quantity] })
    }

    check_for_errors(add_item_forms, remove_quantity_forms)
  end

  def check_for_errors(add_item_forms, remove_quantity_forms)
    unless add_item_forms.all?(&:add_quantity) && remove_quantity_forms.all?(&:remove_quantity)
      add_item_forms.each_with_index do |form, i|
        if !form.errors.empty?
          errors.add(:remove_quantity, "Couldn't add item using add_item_form of index #{i} as following:")
          form.errors.details.each do |key, details|
            details.each do |detail|
              error = detail[:error]
              errors.add(key, error)
            end
          end
        end
      end

      remove_quantity_forms.each_with_index do |form, i|
        if !form.errors.empty?
          errors.add(:remove_quantity, "Couldn't remove quantity using remove_quantity_form from iteminventory ID #{form.inventoryitem[:id]} as following:")
          form.errors.details.each do |key, details|
            details.each do |detail|
              error = detail[:error]
              errors.add(key, error)
            end
          end
        end
      end

      errors.add(:trade, "There was a problem while trying to make the exchange")
      raise ActiveRecord::Rollback
      return false
    end
  end
end
