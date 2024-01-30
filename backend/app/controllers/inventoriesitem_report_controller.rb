require_relative "../queries/inventoriesitem/index_query"

class InventoriesitemReportController < ReportsController
  include InventoryitemQuery
  before_action :set_sorter

  def inventoriesitem_report
    data = InventoryitemQuery::sort_data(@sorter)
    headers = ["ID", "Surv. ID", "Survivor Name", "Inv. ID", "Item ID", "Item Name", "Qty"]
    generate_report("inventoryitem", data, InventoriesitemPdf, headers)
  end
end
