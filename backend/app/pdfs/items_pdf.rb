class ItemsPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(items:)
    super()
    @items = items
  end

  def render_document
    write_header
    write_title('Items')
    write_body do
      write_table(header: ['Name', 'Value', 'Description'], data: @items)
    end

    write_footer
  end
end