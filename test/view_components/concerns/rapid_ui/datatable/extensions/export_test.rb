require "test_helper"

module RapidUI
  module Datatable
    module Extensions
      class ExportTest < ViewComponentTestCase
        include ExtensionSupport
        Record = Struct.new(:id, :name)

        def setup
          @table_class = Class.new(ExtensionSupport::TestComponent) do
            include Export
            include ColumnTypes

            columns do |t|
              t.integer :id
              t.string :name
            end

            def each_row(batch_size: nil, &block)
              yield Record.new(1, "John")
              yield Record.new(2, "Jane")
            end
          end

          @default_json = [ { id: 1, name: "John" }, { id: 2, name: "Jane" } ]
          @override_json = [ { id: "ID: 1.", name: "John" }, { id: "ID: 2.", name: "Jane" } ]

          @default_csv = "id,name\n1,John\n2,Jane\n"
          @override_csv = "id,name\nID: 1.,John\nID: 2.,Jane\n"
        end

        test "#export_method is used for JSON and CSV export" do
          @table_class.class_eval do
            cell_value :id, :export do |record|
              "ID: #{record.id}."
            end
          end

          assert_equal @override_json, table.to_json
          assert_equal @override_csv, table.csv_stream.write(StringIO.new).string
        end

        test "#json_method is used for JSON export, not CSV" do
          @table_class.class_eval do
            cell_value :id, :json do |record|
              "ID: #{record.id}."
            end
          end

          assert_equal @override_json, table.to_json
          assert_equal @default_csv, table.csv_stream.write(StringIO.new).string
        end

        test "#csv_method is used for CSV export, not JSON" do
          @table_class.class_eval do
            cell_value :id, :csv do |record|
              "ID: #{record.id}."
            end
          end

          assert_equal @override_csv, table.csv_stream.write(StringIO.new).string
          assert_equal @default_json, table.to_json
        end

        test "exports control is registered" do
          klass = Class.new ViewComponent::Base do
            include Controls
            include Export
          end

          assert_registers_control :exports, klass
        end

        def table
          @table_class.new
        end

        class LinksTest < ViewComponentTestCase
          described_class Export::Links

          test "links to export formats" do
            render_inline build(%i[csv json], path_proc: ->(format) { "/exports/#{format}" })

            assert_selector "a[href='/exports/csv']", text: "CSV"
            assert_selector "a[href='/exports/json']", text: "JSON"
          end
        end
      end
    end
  end
end
