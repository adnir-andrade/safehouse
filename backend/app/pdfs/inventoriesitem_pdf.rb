class InventoriesitemPdf < ApplicationPdf
  attr_reader :pdf

  def initialize(data:)
    super()
    @inventoriesitem = data
  end

  def render_document
    write_header
    write_title("Inventory / Items")
    write_body do
      write_table(header: ["ID", "Surv. ID", "Survivor Name", "Inv. ID", "Item ID", "Item Name", "Qty"], data: @inventoriesitem)
    end

    write_footer
  end
end
