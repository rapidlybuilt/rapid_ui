# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    class SortingTest < ViewComponent::TestCase
      class SortingTable < ExtensionSupport::TestComponent
        include Sorting
        include ExtensionSupport::PathsHelper

        column :id
        column :name, sortable: true
        column :email, sortable: true, sort_order: "desc"

        self.sort_column = :name
      end

      test "sort_column returns class default when no sort param" do
        table = SortingTable.new
        assert_equal :name, table.sort_column.id
        assert_equal :name, SortingTable.sort_column
      end

      test "sort_column returns column when param matches sortable column" do
        table = SortingTable.new(full_params: { sort: "email" })
        assert_equal :email, table.sort_column&.id
      end

      test "sort_column returns class default when param is invalid" do
        table = SortingTable.new(full_params: { sort: "id" })
        assert_equal :name, table.sort_column.id
      end

      test "sort_order returns param value when valid" do
        table = SortingTable.new(full_params: { sort: "name", dir: "desc" })
        assert_equal "desc", table.sort_order
      end

      test "sort_order defaults to asc when blank" do
        table = SortingTable.new(full_params: { sort: "name" })
        assert_equal "asc", table.sort_order
      end

      test "sort_order uses column default when param missing" do
        table = SortingTable.new(full_params: { sort: "email" })
        assert_equal "desc", table.sort_order
      end

      test "sort_column_param_value returns value when column is sortable" do
        table = SortingTable.new(full_params: { sort: "name" })
        assert_equal "name", table.sort_column_param_value
      end

      test "sort_column_param_value returns nil when column not sortable" do
        table = SortingTable.new(full_params: { sort: "id" })
        assert_nil table.sort_column_param_value
      end

      test "sort_order_param_value returns value when in available_sort_orders" do
        table = SortingTable.new(full_params: { dir: "desc" })
        assert_equal "desc", table.sort_order_param_value
      end

      test "sort_order_param_value returns nil when invalid" do
        table = SortingTable.new(full_params: { dir: "invalid" })
        assert_nil table.sort_order_param_value
      end

      test "available_sort_orders returns asc and desc" do
        table = SortingTable.new
        assert_equal %w[asc desc], table.available_sort_orders
      end

      test "reverse_sort_order toggles asc to desc" do
        table = SortingTable.new
        assert_equal "desc", table.reverse_sort_order("asc")
      end

      test "reverse_sort_order toggles desc to asc" do
        table = SortingTable.new
        assert_equal "asc", table.reverse_sort_order("desc")
      end

      test "filter_sorting raises AdapterRequiredError" do
        table = SortingTable.new
        assert_raises(RapidUI::AdapterRequiredError) { table.filter_sorting([]) }
      end

      test "column_label renders span when skip_sorting" do
        table = SortingTable.new(skip_sorting: true)
        render_inline(table)
        name_column = SortingTable.find_column!(:name)
        html = table.column_label(name_column)
        assert_equal "Name", html
      end

      test "column_label renders span when column not sortable" do
        table = SortingTable.new(full_params: { sort: "name" })
        render_inline(table)
        id_column = SortingTable.find_column!(:id)
        html = table.column_label(id_column)
        assert_equal "Id", html
      end

      test "column_label renders sortable link with correct path and active class when current sort column" do
        table = SortingTable.new(full_params: { sort: "name", dir: "asc" })
        render_inline(table)
        name_column = SortingTable.find_column!(:name)
        html = table.column_label(name_column)
        assert_includes html, "admin-table-header-cell-link"
        assert_includes html, "active"
        assert_includes html, "sort=name"
        assert_includes html, "dir=desc"
      end

      test "column_label renders sortable link with column sort_order when not current sort column" do
        table = SortingTable.new(full_params: { sort: "name", dir: "asc" })
        render_inline(table)
        email_column = SortingTable.find_column!(:email)
        html = table.column_label(email_column)
        assert_includes html, "admin-table-header-cell-link"
        assert_not_includes html, "active"
        assert_includes html, "sort=email"
        assert_includes html, "dir=desc"
      end

      test "sort_order_label returns empty string when column not sortable" do
        table = SortingTable.new
        render_inline(table)
        id_column = SortingTable.find_column!(:id)
        assert_equal "", table.sort_order_label(id_column)
      end

      test "sort_order_label returns span with sort order icon when column sortable" do
        table = SortingTable.new(full_params: { sort: "name", dir: "asc" })
        render_inline(table)
        name_column = SortingTable.find_column!(:name)
        html = table.sort_order_label(name_column)
        assert_includes html, "admin-table-header-sort-order"
        assert_includes html, "▲"
      end

      test "sort_order_icon_label returns both arrows when column not current sort" do
        table = SortingTable.new(full_params: { sort: "name" })
        render_inline(table)
        email_column = SortingTable.find_column!(:email)
        html = table.sort_order_icon_label(email_column)
        assert_includes html, "▲"
        assert_includes html, "▼"
      end

      test "sort_order_icon_label returns asc indicator when current sort is asc" do
        table = SortingTable.new(full_params: { sort: "name", dir: "asc" })
        render_inline(table)
        name_column = SortingTable.find_column!(:name)
        html = table.sort_order_icon_label(name_column)
        assert_includes html, "▲"
        assert_includes html, "&nbsp;"
      end

      test "sort_order_icon_label returns desc indicator when current sort is desc" do
        table = SortingTable.new(full_params: { sort: "name", dir: "desc" })
        render_inline(table)
        name_column = SortingTable.find_column!(:name)
        html = table.sort_order_icon_label(name_column)
        assert_includes html, "▼"
        assert_includes html, "&nbsp;"
      end

      test "offers sugar for setting sortable and the direction in one argument" do
        klass = Class.new do
          include Sorting
          column :name, sortable: "desc"
        end

        assert klass.find_column!(:name).sortable?
        assert_equal "desc", klass.find_column!(:name).sort_order

        klass = Class.new do
          include Sorting
          column :name, sortable: "asc"
        end
        assert klass.find_column!(:name).sortable?
        assert_equal "asc", klass.find_column!(:name).sort_order
      end
    end
  end
end
