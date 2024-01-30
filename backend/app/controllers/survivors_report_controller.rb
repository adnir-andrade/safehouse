require_relative "../queries/survivors/index_query"
require_relative "../queries/survivors/status_query"

class SurvivorsReportController < ReportsController
  include SurvivorQuery

  before_action :set_sorter

  def survivors_report
    data = SurvivorQuery::sort_data(@sorter)
    headers = ['Name', 'Gender', 'Age']
    generate_report("survivor", data, SurvivorsPdf, headers)
  end

  def survivors_status
    data = StatusQuery::filter
    headers = ['Not Infected', 'Infected/Dead']
    generate_report("survivor", data, SurvivorsPdf, headers)
  end
end