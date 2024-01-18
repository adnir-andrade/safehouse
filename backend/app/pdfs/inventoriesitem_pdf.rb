class InventoriesitemPdf < ApplicationPdf
    attr_reader :pdf

    def initialize(data:)
        super()
        @inventoriesitem = data
    end

    def render_document
        write_header
        write_title('Inventories / Item')
        write_body do
        write_table(header: ['ID', 'Owner ID', 'Owner Name', 'Inventory ID', 'Item ID', 'Item Name', 'Quantity'], data: @inventoriesitem)
        end

        write_footer
    end
end