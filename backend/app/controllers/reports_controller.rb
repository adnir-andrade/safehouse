class ReportsController < ApplicationController

  def test_report
    survivors = Survivor.pluck(:name, :gender, :age)
    pdf = SurvivorsPdf.new(survivors: survivors)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: 'test.pdf', type: 'application/pdf', disposition: 'inline')
      end
    end
  end
end