class ReportsController < ApplicationController
  before_action :set_sorter

  def survivors_report
    survivors = Survivor.pluck(:name, :gender, :age)
    sort_survivors(survivors)
    pdf = SurvivorsPdf.new(survivors: survivors)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: 'survivors.pdf', type: 'application/pdf', disposition: 'inline')
      end
    end
  end

  def sort_survivors(survivors)
    case @sorter
    when "name-asc"
      survivors.sort_by! { |survivor| survivor[0] }
    when "name-desc"
      survivors.sort_by! { |survivor| survivor[0] }.reverse!
    when "gender"
      survivors.sort_by! { |survivor| survivor[1] }
    when "age-asc"
      survivors.sort_by! { |survivor| survivor[2] }
    when "age-desc"
      survivors.sort_by! { |survivor| survivor[2] }.reverse!
    else
      return survivors
    end
  end

  def set_sorter
    @sorter = params[:option]
  end
end