require_relative "view_component_test_case"

module RapidUI
  class PropertyTableTest < ViewComponentTestCase
    described_class PropertyTable

    test "renders a basic property table" do
      render_inline build do |table|
        table.with_property("Name", "John Doe")
        table.with_property("Email", "john@example.com")
      end

      assert_selector "table.table.table-property"
      assert_selector "tbody tr th[scope='row']", text: "Name"
      assert_selector "tbody tr td", text: "John Doe"
      assert_selector "tbody tr th[scope='row']", text: "Email"
      assert_selector "tbody tr td", text: "john@example.com"
    end

    test "renders property table with value as block" do
      render_inline build do |table|
        table.with_property("Name") do
          "Block Content"
        end
      end

      assert_selector "table.table.table-property"
      assert_selector "tbody tr th[scope='row']", text: "Name"
      assert_selector "tbody tr td", text: "Block Content"
    end

    test "renders property table with multiple values" do
      render_inline build do |table|
        table.with_property("Status", "Active")
        table.with_property("Role", "Administrator")
        table.with_property("Department", "Engineering")
      end

      assert_selector "table.table.table-property tbody tr", count: 3
      assert_selector "tbody tr th[scope='row']", text: "Status"
      assert_selector "tbody tr td", text: "Active"
      assert_selector "tbody tr th[scope='row']", text: "Role"
      assert_selector "tbody tr td", text: "Administrator"
      assert_selector "tbody tr th[scope='row']", text: "Department"
      assert_selector "tbody tr td", text: "Engineering"
    end

    test "renders property table with with_property alias" do
      render_inline build do |table|
        table.with_property("Name", "Jane Doe")
      end

      assert_selector "table.table.table-property"
      assert_selector "tbody tr th[scope='row']", text: "Name"
      assert_selector "tbody tr td", text: "Jane Doe"
    end

    test "renders property table with striped style" do
      render_inline build(striped: true) do |table|
        table.with_property("Name", "John")
        table.with_property("Email", "john@example.com")
      end

      assert_selector "table.table.table-property.table-striped"
    end

    test "renders property table with hover effect" do
      render_inline build(hover: true) do |table|
        table.with_property("Name", "John")
      end

      assert_selector "table.table.table-property.table-hover"
    end

    test "renders property table with bordered style" do
      render_inline build(bordered: true) do |table|
        table.with_property("Name", "John")
      end

      assert_selector "table.table.table-property.table-bordered"
    end

    test "renders property table with custom CSS class" do
      render_inline build(class: "custom-property-table") do |table|
        table.with_property("Name", "John")
      end

      assert_selector "table.table.table-property.custom-property-table"
    end

    test "renders property table with caption" do
      render_inline build do |table|
        table.with_caption("User Information")
        table.with_property("Name", "John Doe")
      end

      assert_selector "table.table.table-property caption", text: "User Information"
      assert_selector "tbody tr th[scope='row']", text: "Name"
    end

    test "renders responsive property table" do
      render_inline build(responsive: true) do |table|
        table.with_property("Name", "John")
      end

      assert_selector "div.table-responsive table.table.table-property"
    end
  end
end
