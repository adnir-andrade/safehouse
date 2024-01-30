class ItemsPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(data:, headers:)
    super()
    @items = data
    @headers = headers
  end

  def render_document
    write_header
    write_title('Items')
    write_body do
      write_table(header: @headers, data: @items)
    end

    write_footer
  end
end