module IndexQuery
  extend self
  attr_reader :query

  def sort_data(sorter)
    filters = {
      "owner-asc" => -> { get_query("survivors.name ASC") },
      "owner-desc" => -> { get_query("survivors.name DESC") },
      "quantity-asc" => -> { get_query("quantity ASC") },
      "quantity-desc" => -> { get_query("quantity DESC") },
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
      .where("survivors.is_alive": true)
      .order(sorter)

    @query = @query.map do |entry|
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
end
