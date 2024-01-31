require_relative "../queries/inventoriesitem/index_query"
require_relative "../queries/inventoriesitem/item_by_survivor_query"

class InventoriesitemReportController < ReportsController
  include InventoryitemQuery
  before_action :set_sorter

  def inventoriesitem_report
    data = InventoryitemQuery::sort_data(@sorter)
    headers = ["ID", "Surv. ID", "Survivor Name", "Inv. ID", "Item ID", "Item Name", "Qty"]
    title = "Inventory / Items"
    generate_report("inventoryitem", data, InventoriesitemPdf, headers, title)
  end

  def average_item_by_survivor
    data = ItemBySurvivorQuery::sort_data(@sorter)
    headers = ['Item ID', 'Item', 'Avg. Amount By Survivor']
    title = "Items per Survivor"
    generate_report("inventoryitem", data, InventoriesitemPdf, headers, title)
  end
end
