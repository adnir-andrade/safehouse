module IndexQuery
  extend self
  attr_reader :query

  def sort_data(sorter)
    filters = {
      "owner-asc" => -> { sort_by_owner_asc },
      "owner-desc" => -> { sort_by_owner_desc },
      "quantity-asc" => -> { sort_by_quantity_asc },
      "quantity-desc" => -> { sort_by_quantity_desc },
    }

    filters.fetch(sorter, -> {
      get_query
      return @query
    }).call
  end

  private

  def get_query(sorter = "id ASC")
    @query = InventoriesItem
      .joins(:item)
      .joins(:inventory)
      .joins(inventory: :survivor)
      .select(
        "inventories_items.id AS id",
        "survivors.id AS owner_id",
        "survivors.name AS owner_name",
        "inventories.id AS owner_inventory_id",
        "items.id AS item_id",
        "items.name AS item_name",
        "inventories_items.quantity",
      )
      .order(sorter)
      .map do |entry|
      {
        id: entry.id,
        owner_id: entry.owner_id,
        owner_name: entry.owner_name,
        owner_inventory_id: entry.owner_inventory_id,
        item_id: entry.item_id,
        item_name: entry.item_name,
        quantity: entry.quantity,
      }.values
    end
  end

  def sort_by_owner_asc
    get_query("survivors.name ASC")
    return @query
  end

  def sort_by_owner_desc
    get_query("survivors.name DESC")
    return @query
  end

  def sort_by_quantity_asc
    get_query("quantity ASC")
    return @query
  end

  def sort_by_quantity_desc
    get_query("quantity DESC")
    return @query
  end
end
