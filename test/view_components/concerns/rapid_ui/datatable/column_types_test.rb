# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    class ColumnTypesTest < ViewComponent::TestCase
      Record = Struct.new(:name, :count, :price, :active, :amount, :rate, :birthday, :created_at, keyword_init: true)

      class TestTable < ExtensionSupport::TestComponent
        include Columns
        include ColumnTypes

        columns do |t|
          t.string :name
          t.integer :count
          t.float :price
          t.boolean :active
          t.currency :amount
          t.percentage :rate
          t.date :birthday
          t.datetime :created_at
        end

        def call; end
      end

      setup do
        @table = TestTable.new
        render_inline @table
      end

      test "string type renders value as string" do
        record = Record.new(name: "Alice")
        assert_equal "Alice", @table.column_cell_html(record, :name)
      end

      test "integer type formats with thousands separator" do
        record = Record.new(count: 1_234_567)
        assert_equal "1,234,567", @table.column_cell_html(record, :count)
      end

      test "float type formats with two decimal places" do
        record = Record.new(price: 1234.5)
        assert_equal "1,234.50", @table.column_cell_html(record, :price)
      end

      test "boolean type renders Yes or No" do
        assert_equal "Yes", @table.column_cell_html(Record.new(active: true), :active)
        assert_equal "No", @table.column_cell_html(Record.new(active: false), :active)
      end

      test "currency type formats with number_to_currency" do
        record = Record.new(amount: 1234.5)
        assert_equal "$1,234.50", @table.column_cell_html(record, :amount)
      end

      test "percentage type formats decimal as percentage" do
        record = Record.new(rate: 0.75)
        assert_equal "75.00%", @table.column_cell_html(record, :rate)
      end

      test "date type renders formatted date" do
        record = Record.new(birthday: Date.new(2024, 1, 15))
        assert_equal "January 15, 2024", @table.column_cell_html(record, :birthday)
      end

      test "datetime type renders formatted datetime" do
        record = Record.new(created_at: Time.utc(2024, 1, 15, 14, 30))
        result = @table.column_cell_html(record, :created_at)
        assert_includes result, "2024"
        assert_includes result, "January"
      end

      test "nil value is not passed to type block" do
        record = Record.new(name: nil)
        assert_nil @table.column_cell_html(record, :name)
      end
    end
  end
end
