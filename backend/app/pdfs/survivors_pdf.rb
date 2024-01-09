class SurvivorsPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(survivors:)
    @survivors = survivors
  end

  def render_document
    write_header
    write_title('Survivors')
    write_body do
      write_table(header: ['Name', 'Gender', 'Age'], data: @survivors)
    end

    write_footer
  end
end