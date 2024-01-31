module ItemBySurvivorQuery
  extend self
  attr_reader :query

  def sort_data(sorter)
    filters = {
      "id-asc" => -> { get_query("item_id ASC") },
      "id-desc" => -> { get_query("item_id DESC") },
      "item-asc" => -> { get_query("item_name ASC") },
      "item-desc" => -> { get_query("item_name DESC") },
      "avg-asc" => -> { get_query("total_quantity ASC") },
      "avg-desc" => -> { get_query("total_quantity DESC") },
    }

    filters.fetch(sorter, -> {
      get_query
      return @query
    }).call
  end

  private

  def get_query(sorter = "item_id ASC")
    @query = InventoriesItem
      .joins(:item, :inventory)
      .joins(inventory: :survivor)
      .select(
        "items.id AS item_id",
        "items.name AS item_name",
        "SUM(inventories_items.quantity) AS total_quantity",
      )
      .where("survivors.is_alive": true)
      .group("items.id")
      .order(sorter)

    total_survivors = Survivor.where("is_alive": true).count

    @query = @query.map do |entry|
      {
        item_id: entry.item_id,
        item_name: entry.item_name,
        avg_by_survivor: "%.1f" % (entry.total_quantity / total_survivors.to_f),
      }.values
    end
  end

end
