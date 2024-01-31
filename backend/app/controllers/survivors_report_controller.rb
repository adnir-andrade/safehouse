require_relative "../queries/survivors/index_query"
require_relative "../queries/survivors/status_query"

class SurvivorsReportController < ReportsController
  include SurvivorQuery

  before_action :set_sorter

  def survivors_report
    data = SurvivorQuery::sort_data(@sorter)
    headers = ['Name', 'Gender', 'Age']
    title = "Survivors"
    generate_report("survivor", data, headers, title)
  end

  def survivors_status
    data = StatusQuery::filter
    headers = ['Status', 'Quantity', 'Percentage']
    title = "Surivors Status"
    generate_report("survivor", data, headers, title)
  end
end