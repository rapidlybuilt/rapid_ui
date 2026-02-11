# frozen_string_literal: true

require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    class RowsTest < ViewComponentTestCase
      User = Struct.new(:id, :name)

      class TestTable < RapidUI::Datatable::Base
        include Adapters::Array

        columns do |t|
          t.string :id
          t.string :name
        end

        def dom_id(record)
          "user_#{record.id}"
        end
      end

      described_class TestTable

      setup do
        @records = [ User.new(1, "John"), User.new(2, "Jane") ]
      end

      test "rows returns filtered unfiltered_rows and memoizes" do
        table = build(@records, id: "my-table")
        assert_equal @records, table.rows
        assert_same table.rows, table.rows
      end

      test "register_filter applies to scope" do
        table_class = Class.new(TestTable) do
          register_filter(:double) { |_table, scope| scope + scope }
        end
        table = table_class.new(@records, id: "t", factory: factory)
        assert_equal 4, table.rows.size
        assert_equal [ @records, @records ].flatten, table.rows
      end

      test "rows with Proc scope calls proc on first access" do
        called = false
        scope = -> { called = true; @records }
        table = build(scope, id: "my-table")
        assert_not called
        table.rows
        assert called
        assert_equal @records, table.rows
      end

      test "reset_rows clears memoization" do
        table = build(@records, id: "my-table")
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
        table = table_class.new(@records, id: "t", factory: factory)
        table.rows
        assert_equal 1, table.instance_variable_get(:@filter_calls)
        table.reload
        table.rows
        assert_equal 2, table.instance_variable_get(:@filter_calls)
      end

      test "empty? delegates to rows" do
        table = build(@records, id: "my-table")
        assert_not table.empty?
        table = build([], id: "empty")
        assert table.empty?
      end

      test "any? delegates to rows" do
        table = build(@records, id: "my-table")
        assert table.any?
        table = build([], id: "empty")
        assert_not table.any?
      end

      test "row_id returns row.id" do
        table = build(@records, id: "my-table")
        assert_equal 1, table.row_id(@records.first)
        assert_equal 2, table.row_id(@records.last)
      end

      test "row_tag renders tr with dom_id" do
        render_inline build(@records, id: "my-table")
        assert_selector "tr#user_1"
        assert_selector "tr#user_2"
      end
    end
  end
end
