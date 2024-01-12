class ReportsController < ApplicationController
  before_action :set_sorter

  def generate_report(entity_name, entity_class, entity_attributes, pdf_class, sort_method)
    data = entity_class.pluck(entity_attributes)
    sort_method.call(data)
    pdf = pdf_class.new(data: data)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: "#{entity_name}.pdf", type: "application/pdf", disposition: "inline")
      end
    end
  end

  def set_sorter
    @sorter = params[:option]
  end
end