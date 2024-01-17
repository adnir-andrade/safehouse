class InventoriesitemReportController < ReportsController
  def inventoriesitem_report
    data = InventoriesItem
      .joins(:item)
      .joins(:inventory)
      .joins(inventory: :survivor)
      .select(
        'inventories_items.id AS id',
        'items.id AS item_id', 
        'items.name AS item_name', 
        'inventories_items.quantity',
        'survivors.id AS survivor_id', 
        'survivors.name AS owner', 
        'inventories.id AS inventory_id'
        )
      .map do |entry|
      {
        id: entry.id,
        owner: entry.owner,
        item_id: entry.item_id,
        item_name: entry.item_name,
        quantity: entry.quantity
      }.values
    end
    
    generate_report("inventoryitem", data, InventoriesitemPdf, method(:sort_data))
  end

  def sort_data(entries)
    filters = {
      "owner-asc" => -> { entries.sort_by! { |entry| entry[1] } },
      "owner-desc" => -> { entries.sort_by! { |entry| entry[1] } },
      "quantity-asc" => -> { entries.sort_by! { |entry| entry[4] } },
      "quantity-desc" => -> { entries.sort_by! { |entry| entry[4] }.reverse! },
    }

    filters.fetch(@sorter, -> { return }).call
  end
end