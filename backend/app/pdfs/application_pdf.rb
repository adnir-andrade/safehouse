class ApplicationPdf
  include Prawn::View

  def initialize
    update_font_families
  end

  def update_font_families
    font_families.update("montserrat" => {
      :normal => Rails.root.join("app/assets/fonts/MontserratSubrayada-Regular.ttf"),
      :bold => Rails.root.join("app/assets/fonts/MontserratSubrayada-Bold.ttf")
    })

    font_families.update("noto" => {
      :normal => Rails.root.join("app/assets/fonts/NotoSansJP-VariableFont_wght.ttf"),
      :bold => Rails.root.join("app/assets/fonts/NotoSansJP-VariableFont_wght.ttf")
    })

    font_families.update("dm-mono" => {
      :light => Rails.root.join("app/assets/fonts/DMMono-Light.ttf"),
      :normal => Rails.root.join("app/assets/fonts/DMMono-Regular.ttf"),
      :bold => Rails.root.join("app/assets/fonts/DMMono-Medium.ttf")
    })

    fallback_fonts(["noto"])
  end

  def write_header
    repeat(:all) do
      font "montserrat"

      title = 'The Safehouse'
      date_text = "Date: #{Date.today.strftime('%d/%m/%Y')}"

      bounding_box([0, cursor], width: bounds.width, height: 40) do
        image 'app/assets/images/safehouse-logo.png', height: 40, at: [167, 71]
        # image 'app/assets/images/safehouse-logo.png', height: 40, at: [-30, 75]

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
      font "dm-mono"
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
          valign: :center,
          size: 11,
          border_width: 0.5,
          border_color: '7d7c7c',
          padding_bottom: 10
        }
    ) do
      cells.style do |c|
        c.background_color = ((c.row) % 2).zero? ? 'd6d6d6' : 'F0F0F0'
      end

      row(0).style(
        font: "montserrat", 
        font_style: :bold, 
        text_color: "F2F7FE", 
        border_color: '3A1313',
        background_color: "8E0000", 
        size: 13, 
        overflow: :shrink_to_fit, 
        single_line: true
      )
    end
  end

  def write_footer
    repeat(:all, dynamic: true) do
      draw_text page_number, at: [550, -10]
    end
  end
end
