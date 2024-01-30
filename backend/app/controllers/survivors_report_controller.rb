require_relative "../queries/survivors/index_query"

class SurvivorsReportController < ReportsController
  include IndexQuery
  before_action :set_sorter

  def survivors_report
    data = IndexQuery::sort_data(@sorter)
    generate_report("survivor", data, SurvivorsPdf)
  end
end