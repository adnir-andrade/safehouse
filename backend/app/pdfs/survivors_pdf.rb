class SurvivorsPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(data:, headers:)
    super()
    @survivors = data
    @headers = headers
  end

  def render_document
    write_header
    write_title('Survivors')
    write_body do
      write_table(header: @headers, data: @survivors)
    end

    write_footer
  end
end