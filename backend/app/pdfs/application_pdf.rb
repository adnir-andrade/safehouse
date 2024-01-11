class ApplicationPdf
  include Prawn::View

  def write_header
    repeat(:all) do
      font_families.update("safehouse-font" => {
        :normal => Rails.root.join("app/assets/fonts/MontserratSubrayada-Regular.ttf"),
        :bold => Rails.root.join("app/assets/fonts/MontserratSubrayada-Bold.ttf"),
      })
      font "safehouse-font"
      # Use this font only for the title

      title = 'The Safehouse'
      date_text = "Date: #{Date.today.strftime('%d/%m/%Y')}"

      bounding_box([0, cursor], width: bounds.width, height: 40) do
        # image 'app/assets/images/safehouse-logo.png', height: 40, at: [167, 71]
        image 'app/assets/images/safehouse-logo.png', height: 40, at: [-30, 75]

        font_size(17) { draw_text title, at: [15, 45] }
        
        top_right = bounds.width - 15 - width_of(date_text)
        draw_text date_text, at: [top_right, 45]

        stroke_horizontal_rule
      end
    end
  end

  def write_title(title)
    font_size(27) { text title, align: :center, style: :bold }
  end

  def write_body
    bounding_box([0, bounds.top - 80], width: bounds.width) do
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
