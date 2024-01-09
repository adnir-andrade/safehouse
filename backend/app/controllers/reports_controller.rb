class ReportsController < ApplicationController

  def test_report
    survivors = Survivor.pluck(:name, :gender, :age)
    pdf = SurvivorsPdf.new(survivors: survivors)
    pdf.render_document
    send_data(pdf.render, filename: 'test.pdf', type: 'application/pdf', disposition: 'inline')

    # respond_to do |format|
    #   format.pdf do
    #   end
    # end
  end
end