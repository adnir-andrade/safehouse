require_relative "../queries/items/index_query"

class ItemsReportController < ReportsController
  include ItemQuery
  before_action :set_sorter

  def items_report
    data = ItemQuery::sort_data(@sorter)
    headers = ['Name', 'Value', 'Description']
    title = "Items"
    generate_report("item", data, ItemsPdf, headers, title)
  end
end