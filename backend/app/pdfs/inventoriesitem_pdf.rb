class InventoriesitemPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(data:, headers:)
    super()
    @inventoriesitem = data
    @headers = headers
  end

  def render_document
    write_header
    write_title("Inventory / Items")
    write_body do
      write_table(header: @headers, data: @inventoriesitem)
    end

    write_footer
  end
end
