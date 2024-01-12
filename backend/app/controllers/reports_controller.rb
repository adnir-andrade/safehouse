class ReportsController < ApplicationController
  before_action :set_sorter

  def generate_report(entity_name, entity_class, entity_attributes, pdf_class, sort_method)
    data = entity_class.pluck(entity_attributes)
    sort_method.call(data)
    pdf = pdf_class.new(data: data)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: "#{entity_name}.pdf", type: "application/pdf", disposition: "inline")
      end
    end
  end

  def survivors_report
    generate_report("survivor", Survivor, [:name, :gender, :age], SurvivorsPdf, method(:sort_survivors))
  end

  def items_report
    generate_report("item", Item, [:name, :value, :description], ItemsPdf, method(:sort_items))
  end

  def sort_survivors(survivors)
    filters = {
      "name-asc" => -> { survivors.sort_by! { |survivor| survivor[0] } },
      "name-desc" => -> { survivors.sort_by! { |survivor| survivor[0] }.reverse! },
      "gender" => -> { survivors.sort_by! { |survivor| survivor[1] } },
      "age-asc" => -> { survivors.sort_by! { |survivor| survivor[2] } },
      "age-desc" => -> { survivors.sort_by! { |survivor| survivor[2] }.reverse! },
    }

    filters.fetch(@sorter, -> { return }).call
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

  def set_sorter
    @sorter = params[:option]
  end
end
