require_relative "../queries/inventoriesitem/index_query"

class InventoriesitemReportController < ReportsController
  include IndexQuery
  before_action :set_sorter

  def inventoriesitem_report
    data = IndexQuery::sort_data(@sorter)
    generate_report("inventoryitem", data, InventoriesitemPdf, method(:sort_data))
  end
end
