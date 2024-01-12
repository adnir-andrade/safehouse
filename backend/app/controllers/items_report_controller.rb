class ItemsReportController < ReportsController
    def items_report
        generate_report("item", Item, [:name, :value, :description], ItemsPdf, method(:sort_items))
      end
    
      def sort_items(items)
        filters = {
          "name-asc" => -> { items.sort_by! { |item| item[0] } },
          "name-desc" => -> { items.sort_by! { |item| item[0] }.reverse! },
          "value-asc" => -> { items.sort_by! { |item| item[1] } },
          "value-desc" => -> { items.sort_by! { |item| item[1] }.reverse! },
          "description" => -> { items.sort_by! { |item| item[2] } },
        }
    
        filters.fetch(@sorter, -> { return }).call
      end
end