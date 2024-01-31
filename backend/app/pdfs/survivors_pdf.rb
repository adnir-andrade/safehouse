class SurvivorsPdf < ApplicationPdf
  attr_reader :pdf

  # TODO: Check if wouldn't be better to just refactor all of this. Is too redundant by now.

  def initialize(data:, headers:, title:)
    super()
    @survivors = data
    @headers = headers
    @title = title
  end

  def render_document
    write_header
    write_title(@title)
    write_body do
      write_table(header: @headers, data: @survivors)
    end

    write_footer
  end
end