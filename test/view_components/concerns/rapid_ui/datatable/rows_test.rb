# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    class RowsTest < ViewComponent::TestCase
      User = Struct.new(:id, :name)

      class TestTable < ExtensionSupport::TestComponent
        include Rows
        include Adapters::Array

        def initialize(unfiltered_rows, **kwargs)
          super(unfiltered_rows:, **kwargs)
        end

        # columns do |t|
        #   t.string :id
        #   t.string :name
        # end

        def dom_id(record)
          "user_#{record.id}"
        end
      end

      setup do
        @records = [ User.new(1, "John"), User.new(2, "Jane") ]
      end

      test "rows returns filtered unfiltered_rows and memoizes" do
        table = TestTable.new(@records)
        assert_equal @records, table.rows
        assert_same table.rows, table.rows
      end

      test "register_filter applies to scope" do
        table_class = Class.new(TestTable) do
          register_filter(:double) { |_table, scope| scope + scope }
        end
        table = table_class.new(@records)
        assert_equal 4, table.rows.size
        assert_equal [ @records, @records ].flatten, table.rows
      end

      test "rows with Proc scope calls proc on first access" do
        called = false
        scope = -> { called = true; @records }
        table = TestTable.new(scope)
        assert_not called
        table.rows
        assert called
        assert_equal @records, table.rows
      end

      test "reset_rows clears memoization" do
        table = TestTable.new(@records)
        first = table.rows
        table.reset_rows
        second = table.rows
        assert_equal first, second
        refute_same first, second
      end

      test "reload calls reset_rows so rows are recomputed" do
        table_class = Class.new(TestTable) do
          register_filter(:count_calls) do |t, scope|
            t.instance_variable_set(:@filter_calls, (t.instance_variable_get(:@filter_calls) || 0) + 1)
            scope
          end
        end
        table = table_class.new(@records)
        table.rows
        assert_equal 1, table.instance_variable_get(:@filter_calls)
        table.reset_rows
        table.rows
        assert_equal 2, table.instance_variable_get(:@filter_calls)
      end

      test "empty? delegates to rows" do
        table = TestTable.new(@records)
        assert_not table.empty?
        table = TestTable.new([])
        assert table.empty?
      end

      test "any? delegates to rows" do
        table = TestTable.new(@records)
        assert table.any?
        table = TestTable.new([])
        assert_not table.any?
      end

      test "row_id returns row.id" do
        table = TestTable.new(@records)
        assert_equal 1, table.row_id(@records.first)
        assert_equal 2, table.row_id(@records.last)
      end

      test "row_tag renders tr with dom_id" do
        html = TestTable.new(@records).row_tag(@records.first) { "content" }
        assert_equal %(<tr id="user_1">content</tr>), html
      end
    end
  end
end
