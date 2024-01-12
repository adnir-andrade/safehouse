class ReportsController < ApplicationController
  before_action :set_sorter

  def survivors_report
    survivors = Survivor.pluck(:name, :gender, :age)
    sort_survivors(survivors)
    pdf = SurvivorsPdf.new(survivors: survivors)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: "survivors.pdf", type: "application/pdf", disposition: "inline")
      end
    end
  end

  def items_report
    items = Item.pluck(:name, :value, :description)
    sort_items(items)
    pdf = ItemsPdf.new(items: items)
    pdf.render_document

    respond_to do |format|
      format.pdf do
        send_data(pdf.render, filename: "items.pdf", type: "application/pdf", disposition: "inline")
      end
    end
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
