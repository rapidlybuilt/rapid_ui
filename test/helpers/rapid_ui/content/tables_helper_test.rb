require_relative "../helper_test_case"

module RapidUI
  module Content
    class TablesHelperTest < HelperTestCase
      include RapidUI::Content::TablesHelper

      test "new_table returns a Table component" do
        table = new_table
        assert_instance_of Table, table
      end

      test "new_table accepts options" do
        table = new_table(striped: true, hover: true)
        assert_equal true, table.striped
        assert_equal true, table.hover
      end

      test "new_table accepts block for configuration" do
        table = new_table do |t|
          t.striped = true
          t.bordered = true
        end

        assert_equal true, table.striped
        assert_equal true, table.bordered
      end

      test "table helper renders table" do
        html = table(striped: true) do |t|
          t.with_body do |body|
            body.with_row do |row|
              row.with_cell("Test Content")
            end
          end
        end

        render_inline html
        assert_selector "table.table.table-striped"
        assert_selector "tbody tr td", text: "Test Content"
      end

      test "table helper renders with multiple options" do
        html = table(striped: true, hover: true, bordered: true) do |t|
          t.with_body do |body|
            body.with_row do |row|
              row.with_cell("Test")
            end
          end
        end

        render_inline html
        assert_selector "table.table.table-striped.table-hover.table-bordered"
      end

      test "new_property_table returns a PropertyTable component" do
        property_table = new_property_table
        assert_instance_of PropertyTable, property_table
      end

      test "new_property_table accepts options" do
        property_table = new_property_table(striped: true, bordered: true)
        assert_equal true, property_table.striped
        assert_equal true, property_table.bordered
      end

      test "new_property_table accepts block for configuration" do
        property_table = new_property_table do |pt|
          pt.striped = true
        end

        assert_equal true, property_table.striped
      end

      test "property_table helper renders property table" do
        html = property_table do |pt|
          pt.with_property("Name", "John Doe")
          pt.with_property("Email", "john@example.com")
        end

        render_inline html
        assert_selector "table.table.table-property"
        assert_selector "tbody tr th[scope='row']", text: "Name"
        assert_selector "tbody tr td", text: "John Doe"
        assert_selector "tbody tr th[scope='row']", text: "Email"
        assert_selector "tbody tr td", text: "john@example.com"
      end

      test "property_table helper with options" do
        html = property_table(striped: true, hover: true) do |pt|
          pt.with_property("Status", "Active")
        end

        render_inline html
        assert_selector "table.table.table-property.table-striped.table-hover"
        assert_selector "tbody tr th[scope='row']", text: "Status"
        assert_selector "tbody tr td", text: "Active"
      end
    end
  end
end
