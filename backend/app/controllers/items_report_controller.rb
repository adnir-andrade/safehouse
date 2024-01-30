require_relative "../queries/items/index_query"

class ItemsReportController < ReportsController
  include IndexQuery
  before_action :set_sorter

  def items_report
    data = IndexQuery::sort_data(@sorter)
    generate_report("item", data, ItemsPdf)
  end
end