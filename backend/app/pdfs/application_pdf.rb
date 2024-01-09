class ApplicationPdf
  include Prawn::View

  def write_header
    repeat(:all) do
      bounding_box([0, cursor], width: bounds.width, height: 80) do
        font_size(25) { draw_text 'Testing Safehouse APP', at: [60, 45] }
        move_down 10
        draw_text "Date: #{Date.today.strftime('%d/%m/%Y')}", at: [60, cursor]
      end
    end
  end

  def write_title(title)
    font_size(25) { text title, align: :center, style: :bold }
    move_down 10
  end

  def write_body
    bounding_box([0, bounds.top - 100], width: bounds.width) do
      yield
    end
  end

  def write_table(data:, header:, width: bounds.width)
    table(
      [header] + data,
      width: width,
      cell_style:
        {
          align: :center,
          size: 12,
          border_width: 0.5,
          border_color: 'B0B0B0',
          padding_top: 10,
          padding_bottom: 10
        }
    ) do
      row(0).style(font_style: :bold, background_color: "F0F0F0", align: :center, size: 14)
      column(1).style(width: 100)
    end
  end

  def write_footer
    repeat(:all, dynamic: true) do
      draw_text page_number, at: [550, -10]
    end
  end
end
