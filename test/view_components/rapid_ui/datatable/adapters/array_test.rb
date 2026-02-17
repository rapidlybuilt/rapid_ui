# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Adapters
      class ArrayTest < ViewComponentTestCase
        User = Struct.new(:id, :name, :email, keyword_init: true)

        class TestTable < RapidUI::Datatable::Base
          include Adapters::Array

          columns do |t|
            t.string :id
            t.string :name, searchable: true, sortable: true
            t.string :email, searchable: true, sortable: true
          end

          self.sort_column = :name
          self.sort_order = "asc"

          def dom_id(record)
            "user_#{record.id}"
          end
        end

        described_class TestTable

        setup do
          @records = [
            User.new(id: 1, name: "Alice", email: "alice@example.com"),
            User.new(id: 2, name: "Bob", email: "bob@example.com"),
            User.new(id: 3, name: "Charlie", email: "charlie@example.com"),
            User.new(id: 4, name: "Diana", email: "diana@example.org"),
          ]
        end

        # Search tests
        test "filter_search returns all rows when search query is blank" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: {} })
          assert_equal 4, table.rows.size
          assert_equal @records.map(&:name), table.rows.map(&:name)
        end

        test "filter_search returns matching rows when query matches name" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "alice" } })
          assert_equal 1, table.rows.size
          assert_equal "Alice", table.rows.first.name
        end

        test "filter_search returns matching rows when query matches email" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "example.org" } })
          assert_equal 1, table.rows.size
          assert_equal "Diana", table.rows.first.name
        end

        test "filter_search is case insensitive" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "BOB" } })
          assert_equal 1, table.rows.size
          assert_equal "Bob", table.rows.first.name
        end

        test "filter_search returns multiple rows when query matches multiple records" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "example.com" } })
          assert_equal 3, table.rows.size
          assert_equal %w[Alice Bob Charlie], table.rows.map(&:name).sort
        end

        test "filter_search returns empty when no searchable columns match" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "xyz" } })
          assert_equal 0, table.rows.size
        end

        # Sorting tests
        test "filter_sorting sorts by column ascending when sort_order is asc" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { sort: "name", dir: "asc" } })
          assert_equal %w[Alice Bob Charlie Diana], table.rows.map(&:name)
        end

        test "filter_sorting sorts by column descending when sort_order is desc" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { sort: "name", dir: "desc" } })
          assert_equal %w[Diana Charlie Bob Alice], table.rows.map(&:name)
        end

        test "filter_sorting sorts by different column when sort param changes" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { sort: "email", dir: "asc" } })
          assert_equal %w[alice@example.com bob@example.com charlie@example.com diana@example.org], table.rows.map(&:email)
        end

        test "filter_sorting uses default sort column when no sort param" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: {} })
          assert_equal %w[Alice Bob Charlie Diana], table.rows.map(&:name)
        end

        test "filter_sorting puts nil values at the end when ascending" do
          records_with_nil = [
            User.new(id: 1, name: "Alice", email: "alice@example.com"),
            User.new(id: 2, name: nil, email: "bob@example.com"),
            User.new(id: 3, name: "Charlie", email: "charlie@example.com"),
          ]
          table = build(records_with_nil, id: "t", param_name: :t, full_params: { t: { sort: "name", dir: "asc" } })
          names = table.rows.map(&:name)
          assert_equal "Alice", names.first
          assert_equal "Charlie", names[1]
          assert_nil names.last
        end

        test "search and sorting work together" do
          table = build(@records, id: "t", param_name: :t, full_params: { t: { q: "example.com", sort: "name", dir: "desc" } })
          assert_equal 3, table.rows.size
          assert_equal %w[Charlie Bob Alice], table.rows.map(&:name)
        end
      end
    end
  end
end
