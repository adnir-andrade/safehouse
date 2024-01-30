class ReportsController < ApplicationController
  before_action :set_sorter

  def generate_report(entity_name, data, pdf_class, headers)
    respond_to do |format|
      format.pdf do
        pdf = pdf_class.new(data: data, headers: headers)
        pdf.render_document
        send_data(pdf.render, filename: "#{entity_name}.pdf", type: "application/pdf", disposition: "inline")
      end
    end
  end

  def set_sorter
    @sorter = params[:option]
  end
end