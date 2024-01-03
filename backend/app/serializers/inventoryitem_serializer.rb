class InventoryitemSerializer < ActiveModel::Serializer
  
  attributes :id, :item, :owner

  def item
    { id: object.item.id, name: object.item.name, quantity: object.quantity }
  end

  def owner
    { id: object.inventory.survivor.id, name: object.inventory.survivor.name, inventory_id: object.inventory_id }
  end

end
