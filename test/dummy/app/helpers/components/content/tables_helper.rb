module Components::Content::TablesHelper
  def component_content_table_basic
    demo_components do |c|
      c << new_table do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_variants
    demo_components do |c|
      c << new_table do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "Variant"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row(variant: "light-primary").tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Light Primary"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row(variant: "light-secondary").tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Light Secondary"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row(variant: "dark-primary").tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Dark Primary"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end

          body.with_row(variant: "dark-secondary").tap do |row|
            row.with_cell "4", scope: "row"
            row.with_cell "Dark Secondary"
            row.with_cell "Sarah"
            row.with_cell "Connor"
            row.with_cell "@sarah"
          end

          body.with_row(variant: "success").tap do |row|
            row.with_cell "5", scope: "row"
            row.with_cell "Success"
            row.with_cell "John"
            row.with_cell "Doe"
            row.with_cell "@johndoe"
          end

          body.with_row(variant: "danger").tap do |row|
            row.with_cell "6", scope: "row"
            row.with_cell "Danger"
            row.with_cell "Jane"
            row.with_cell "Smith"
            row.with_cell "@janesmith"
          end

          body.with_row(variant: "warning").tap do |row|
            row.with_cell "7", scope: "row"
            row.with_cell "Warning"
            row.with_cell "Bob"
            row.with_cell "Johnson"
            row.with_cell "@bob"
          end

          body.with_row(variant: "info").tap do |row|
            row.with_cell "8", scope: "row"
            row.with_cell "Info"
            row.with_cell "Alice"
            row.with_cell "Williams"
            row.with_cell "@alice"
          end
        end
      end
    end
  end

  def component_content_table_striped
    demo_components do |c|
      c << new_table(striped: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end

          body.with_row.tap do |row|
            row.with_cell "4", scope: "row"
            row.with_cell "John"
            row.with_cell "Doe"
            row.with_cell "@johndoe"
          end
        end
      end
    end
  end

  def component_content_table_hover
    demo_components do |c|
      c << new_table(hover: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_active
    demo_components do |c|
      c << new_table do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row(active: true).tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_bordered
    demo_components do |c|
      c << new_table(bordered: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_borderless
    demo_components do |c|
      c << new_table(borderless: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_small
    demo_components do |c|
      c << new_table(small: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Larry"
            row.with_cell "Bird"
            row.with_cell "@twitter"
          end
        end
      end
    end
  end

  def component_content_table_align_top
    demo_components do |c|
      c << new_table(align: :top).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "Heading 1"
            row.with_cell "Heading 2"
            row.with_cell "Heading 3"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "This cell has a lot of content that spans multiple lines to demonstrate vertical alignment behavior in table cells."
            row.with_cell "Short"
            row.with_cell "Content"
          end
        end
      end
    end
  end

  def component_content_table_align_middle
    demo_components do |c|
      c << new_table(align: :middle).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "Heading 1"
            row.with_cell "Heading 2"
            row.with_cell "Heading 3"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "This cell has a lot of content that spans multiple lines to demonstrate vertical alignment behavior in table cells."
            row.with_cell "Short"
            row.with_cell "Content"
          end
        end
      end
    end
  end

  def component_content_table_align_bottom
    demo_components do |c|
      c << new_table(align: :bottom).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "Heading 1"
            row.with_cell "Heading 2"
            row.with_cell "Heading 3"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "This cell has a lot of content that spans multiple lines to demonstrate vertical alignment behavior in table cells."
            row.with_cell "Short"
            row.with_cell "Content"
          end
        end
      end
    end
  end

  def component_content_table_caption_top
    demo_components do |c|
      c << new_table do |table|
        table.with_caption("List of users")

        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end
        end
      end
    end
  end

  def component_content_table_caption_bottom
    demo_components do |c|
      c << new_table do |table|
        table.with_caption("List of users shown below", position: :bottom)

        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "First"
            row.with_cell "Last"
            row.with_cell "Handle"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Mark"
            row.with_cell "Otto"
            row.with_cell "@mdo"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Jacob"
            row.with_cell "Thornton"
            row.with_cell "@fat"
          end
        end
      end
    end
  end

  def component_content_table_responsive
    demo_components do |c|
      c << new_table(responsive: true).tap do |table|
        table.with_head.tap do |head|
          head.with_row.tap do |row|
            row.with_cell "#"
            row.with_cell "Heading 1"
            row.with_cell "Heading 2"
            row.with_cell "Heading 3"
            row.with_cell "Heading 4"
            row.with_cell "Heading 5"
            row.with_cell "Heading 6"
            row.with_cell "Heading 7"
            row.with_cell "Heading 8"
            row.with_cell "Heading 9"
          end
        end

        table.with_body.tap do |body|
          body.with_row.tap do |row|
            row.with_cell "1", scope: "row"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
          end

          body.with_row.tap do |row|
            row.with_cell "2", scope: "row"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
          end

          body.with_row.tap do |row|
            row.with_cell "3", scope: "row"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
            row.with_cell "Cell"
          end
        end
      end
    end
  end
end
