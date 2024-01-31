class ItemsPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(data:, headers:, title:)
    super()
    @items = data
    @headers = headers
    @title = title
  end

  def render_document
    write_header
    write_title(@title)
    write_body do
      write_table(header: @headers, data: @items)
    end

    write_footer
  end
end