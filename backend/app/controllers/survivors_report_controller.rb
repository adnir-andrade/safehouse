class SurvivorsReportController < ReportsController
  def survivors_report
    data = Survivor.pluck([:name, :gender, :age])

    generate_report("survivor", data, SurvivorsPdf, method(:sort_survivors))
  end

  def sort_survivors(survivors)
    filters = {
      "name-asc" => -> { survivors.sort_by! { |survivor| survivor[0] } },
      "name-desc" => -> { survivors.sort_by! { |survivor| survivor[0] }.reverse! },
      "gender" => -> { survivors.sort_by! { |survivor| survivor[1] } },
      "age-asc" => -> { survivors.sort_by! { |survivor| survivor[2] } },
      "age-desc" => -> { survivors.sort_by! { |survivor| survivor[2] }.reverse! },
    }

    filters.fetch(@sorter, -> { return }).call
  end
end