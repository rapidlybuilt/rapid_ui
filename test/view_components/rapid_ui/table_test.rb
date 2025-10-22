require_relative "view_component_test_case"

module RapidUI
  class TableTest < ViewComponentTestCase
    described_class Table

    test "renders a basic table" do
      render_inline build do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Cell 1")
            row.with_cell("Cell 2")
          end
        end
      end

      assert_selector "table.table"
      assert_selector "tbody tr td", text: "Cell 1"
      assert_selector "tbody tr td", text: "Cell 2"
    end

    test "renders table with striped style" do
      render_inline build(striped: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-striped"
    end

    test "renders table with hover effect" do
      render_inline build(hover: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-hover"
    end

    test "renders table with bordered style" do
      render_inline build(bordered: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-bordered"
    end

    test "renders table with borderless style" do
      render_inline build(borderless: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-borderless"
    end

    test "renders table with small size" do
      render_inline build(small: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-sm"
    end

    test "renders table with align option" do
      render_inline build(align: "middle") do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-align-middle"
    end

    test "renders table with multiple style options" do
      render_inline build(striped: true, hover: true, bordered: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.table-striped.table-hover.table-bordered"
    end

    test "renders table with caption" do
      render_inline build do |table|
        table.with_caption("Table Caption")
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table caption", text: "Table Caption"
    end

    test "renders table with caption at bottom" do
      render_inline build do |table|
        table.with_caption("Bottom Caption", position: :bottom)
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table caption.caption-bottom", text: "Bottom Caption"
    end

    test "renders table with head" do
      render_inline build do |table|
        table.with_head do |head|
          head.with_row do |row|
            row.with_cell("Header 1")
            row.with_cell("Header 2")
          end
        end
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Data 1")
            row.with_cell("Data 2")
          end
        end
      end

      assert_selector "table.table thead tr th[scope='col']", text: "Header 1"
      assert_selector "table.table thead tr th[scope='col']", text: "Header 2"
      assert_selector "table.table tbody tr td", text: "Data 1"
    end

    test "renders table with foot" do
      render_inline build do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Data")
          end
        end
        table.with_foot do |foot|
          foot.with_row do |row|
            row.with_cell("Footer")
          end
        end
      end

      assert_selector "table.table tbody tr td", text: "Data"
      assert_selector "table.table tfoot tr td", text: "Footer"
    end

    test "renders row with variant" do
      render_inline build do |table|
        table.with_body do |body|
          body.with_row(variant: "success") do |row|
            row.with_cell("Success Row")
          end
        end
      end

      assert_selector "table.table tbody tr.table-success", text: "Success Row"
    end

    test "renders row with active state" do
      render_inline build do |table|
        table.with_body do |body|
          body.with_row(active: true) do |row|
            row.with_cell("Active Row")
          end
        end
      end

      assert_selector "table.table tbody tr.table-active", text: "Active Row"
    end

    test "renders head cells as th elements with scope" do
      render_inline build do |table|
        table.with_head do |head|
          head.with_row do |row|
            row.with_cell("Column 1")
            row.with_cell("Column 2")
          end
        end
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Data 1")
            row.with_cell("Data 2")
          end
        end
      end

      assert_selector "table.table thead tr th[scope='col']", text: "Column 1"
      assert_selector "table.table thead tr th[scope='col']", text: "Column 2"
      assert_selector "table.table tbody tr td", text: "Data 1"
      assert_selector "table.table tbody tr td", text: "Data 2"
    end

    test "renders responsive table" do
      render_inline build(responsive: true) do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "div.table-responsive table.table"
    end

    test "renders responsive table with breakpoint" do
      render_inline build(responsive: "md") do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "div.table-responsive-md table.table"
    end

    test "renders table with custom CSS class" do
      render_inline build(class: "custom-table") do |table|
        table.with_body do |body|
          body.with_row do |row|
            row.with_cell("Test")
          end
        end
      end

      assert_selector "table.table.custom-table"
    end
  end
end
