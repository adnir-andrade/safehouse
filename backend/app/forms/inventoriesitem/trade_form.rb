class Inventoriesitem::TradeForm
  include ActiveModel::Model

  attr_accessor :inventoryitem, :items_wanted, :items_offered, :buyer, :seller

  validates :items_wanted, presence: true
  validates :items_offered, presence: true

  # def quantity=(value)
  #   @quantity = value.to_i.abs
  # end

  def buyer=(id)
    @buyer = Survivor.find(id)
  end

  def seller=(id)
    @seller = Survivor.find(id)
  end

  def initialize(attributes = {})
    super
    @buyer_items = set_trade_items(buyer, items_offered)
    @seller_items = set_trade_items(seller, items_wanted)
  end

  def start_trade
    return false if !has_enough_wanted_items?
    return false if invalid?
    exchange_items
  end

  private

  def exchange_items
    InventoriesItem.transaction do
      puts "GETTING ITEMS FROM VENDOR TO BUYER"
      add_item_forms = []
      remove_quantity_forms = []
      test = InventoriesItem.new()
      items_wanted.each { |item| 
        add_item_forms << Inventoriesitem::AddItemForm.new({inventory_id: @buyer[:inventory_id], item_id: item[:item_id], quantity: item[:quantity]})
        # TODO: Change this part later to deal with stack size
        seller_items = @seller_items.select { |i| i.item_id == item[:item_id]}
        remove_quantity_forms << Inventoriesitem::RemoveQuantityForm.new({inventoryitem: seller_items.first, quantity: item[:quantity]})
      }

      unless add_item_forms.all?(&:add_quantity) && remove_quantity_forms.all?(&:remove_quantity)
        errors.add(:trade, 'There was a problem while trying to make the exchange')
        raise ActiveRecord::Rollback
        return false
      end

      puts "GETTING ITEMS FROM BUYER TO VENDOR"
      add_item_forms = []
      remove_quantity_forms = []
      items_offered.each { |item| 
        # TODO: Change this part later to deal with stack size
        add_item_forms << Inventoriesitem::AddItemForm.new({inventory_id: @seller[:inventory_id], item_id: item[:item_id], quantity: item[:quantity]})
        buyer_items = @buyer_items.select { |i| i.item_id == item[:item_id]}
        remove_quantity_forms << Inventoriesitem::RemoveQuantityForm.new({inventoryitem: buyer_items.first, quantity: item[:quantity]})
      }

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
            errors.add(:remove_quantity, "Couldn't remove quantity using remove_quantity_form of index #{i} as following:")
            form.errors.details.each do |key, details|
              details.each do |detail|
                error = detail[:error]
                errors.add(key, error)
              end
            end
          end
        end
        
        errors.add(:trade, 'There was a problem while trying to make the exchange')
        raise ActiveRecord::Rollback
        return false
      end
    end
    
    return true
  end
  
  def set_trade_items(survivor, items)
    items_id = []
    items.each { |item|
      items_id << item[:item_id]
    }
    return InventoriesItem.where("inventory_id = #{survivor.inventory_id} AND item_id IN (#{items_id.join(', ')})")
  end

  # TODO: Apparently, gotta check from the fucking buyer as well
  def has_enough_wanted_items?
    items_wanted.each { |item_wanted|
      seller_items = @seller_items.select { |i| i.item_id == item_wanted[:item_id]}
      items_in_stock = get_quantity(seller_items)

      if item_wanted[:quantity] > items_in_stock
        # Alternatively: Would be a good idea to set the desired quantity to the max. quantity available in this case.
        # But I think, for now, this is good.
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