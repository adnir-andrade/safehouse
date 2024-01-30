class Inventoriesitem::TradeForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :buyer, :vendor

  validates :buyer, presence: true
  validates :vendor, presence: true
  validate :is_survivor_alive?

  def initialize(attributes = {})
    super
    @buyer_entity = set_entity(buyer)
    @vendor_entity = set_entity(vendor)

    @buyer_offer = set_trade_offers(@buyer_entity, buyer)
    @vendor_offer = set_trade_offers(@vendor_entity, vendor)
  end

  def start_trade
    return false if !has_enough_resources?(@buyer_entity, @buyer_offer)
    return false if !has_enough_resources?(@vendor_entity, @vendor_offer)
    return false if !can_buyer_afford?
    return false if invalid?
    trade
    return true
  end

  private

  def is_survivor_alive?
    return if @buyer_entity[:is_alive] && @vendor_entity[:is_alive]

    if !@buyer_entity[:is_alive]
      errors.add(:survivor, "Buyer is either dead or infected and can't proceed with this trade")
    end

    if !@vendor_entity[:is_alive]
      errors.add(:survivor, "Vendor is either dead or infected and can't proceed with this trade")
    end
  end

  def set_entity(entity)
    return Survivor.find(entity[:survivor_id])
  end

  def set_trade_offers(survivor, entity)
    final_offer = {}
    items = []

    entity[:offers].each { |offer|
      item = {}
      item[:inventoryitem_id], item[:item_id], item[:quantity_available] = InventoriesItem.where(
        item_id: offer[:item_id],
        inventory_id: survivor[:inventory_id],
      ).pluck(:id, :item_id, :quantity).first
      item[:quantity_offered] = offer[:quantity]
      items << item
    }

    final_offer[:items] = items
    final_offer[:cash] = entity[:cash].abs
    final_offer[:total_value] = calculate_total(final_offer)
    return final_offer
  end

  def calculate_total(offer)
    total = 0
    offer[:items].each { |item|
      value = Item.where(id: item[:item_id]).pluck(:value).first
      total += item[:quantity_offered] * value
    }

    total += offer[:cash]

    return total
  end

  def has_enough_resources?(survivor, offer)
    offer[:items].each { |item|
      if item[:quantity_offered] > item[:quantity_available]
        errors.add(:quantity, "Survivor ID #{survivor[:id]} doesn't have enough from Item ID #{item[:item_id]} to be traded.")
        return false
      end

      if offer[:cash] > survivor[:wallet]
        errors.add(:cash, "Survivor ID #{survivor[:id]} doesn't have enough cash in his wallet to trade.")
        return false
      end
    }

    return true
  end

  def can_buyer_afford?
    if @buyer_offer[:total_value] < @vendor_offer[:total_value]
      errors.add(:money, "The buyer doesn't have enough to offer to proceed with this trade. Please offer more cash or items.")
      return false
    end

    return true
  end

  def trade
    InventoriesItem.transaction do
      puts "GETTING GOODS FROM VENDOR TO BUYER"
      transfer_items(@vendor_offer, @buyer_entity)
      transfer_cash(@vendor_entity, @buyer_entity, @vendor_offer[:cash])

      puts "GETTING GOODS FROM BUYER TO VENDOR"
      transfer_items(@buyer_offer, @vendor_entity)
      transfer_cash(@buyer_entity, @vendor_entity, @buyer_offer[:cash])
    end

    return true
  end

  def transfer_items(sender, receiver)
    add_item_forms = []
    remove_quantity_forms = []
    sender[:items].each { |item|
      # TODO: Consider changing this part to deal with stack size
      add_item_forms << Inventoriesitem::AddItemForm.new(
        { inventory_id: receiver[:inventory_id],
          item_id: item[:item_id],
          quantity: item[:quantity_offered] }
      )

      remove_quantity_forms << Inventoriesitem::RemoveQuantityForm.new(
        { inventoryitem: item[:inventoryitem_id],
          quantity: item[:quantity_offered] }
      )
    }

    check_for_errors(add_item_forms, remove_quantity_forms)
  end

  def transfer_cash(sender, receiver, cash)
    receiver.change_wallet_funds(cash)

    unless sender.change_wallet_funds(-cash)
      errors.add(:wallet, "Cannot change wallet of survivor ID #{sender[:id]} because it will go bankrupt!")
    end
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
