class ReportsController < ApplicationController

  def survivors_report
    survivors = Survivor.pluck(:name, :gender, :age)
    # TODO: Make a switch or something else to sort conditional to what the user wants
    sorted_survivors = survivors.sort_by { |survivor| survivor.first }
    pdf = SurvivorsPdf.new(survivors: sorted_survivors)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: 'survivors.pdf', type: 'application/pdf', disposition: 'inline')
      end
    end
  end
end