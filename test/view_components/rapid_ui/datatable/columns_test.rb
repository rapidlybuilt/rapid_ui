require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    module ColumnsTest
      Record = Struct.new(:id, :name, :email, keyword_init: true)

      class BasicTest < ViewComponent::TestCase
        class TestTable < ViewComponent::Base
          include Columns

          column :id
          column :name

          def call; end
        end

        setup do
          @table = TestTable.new
          render_inline @table
        end

        test "column_label returns a span with the column label" do
          id_column = @table.columns.find { |c| c.id == :id }
          name_column = @table.columns.find { |c| c.id == :name }

          assert_includes @table.column_label(id_column).to_s, "Id"
          assert_includes @table.column_label(id_column).to_s, "<span"
          assert_includes @table.column_label(name_column).to_s, "Name"
        end

        test "column_cell_html returns the cell value for the record and column" do
          record = Record.new(id: 1, name: "John")
          id_column = @table.columns.find { |c| c.id == :id }
          name_column = @table.columns.find { |c| c.id == :name }

          assert_equal 1, @table.column_cell_html(record, id_column)
          assert_equal "John", @table.column_cell_html(record, name_column)
        end
      end

      class ClassLevelTest < ViewComponent::TestCase
        setup do
          @table_class = Class.new(ViewComponent::Base) do
            include Columns

            def call; end
          end
        end

        test "column_groups" do
          @table_class.class_eval do
            column :id
            column :name
            column :email

            column_group :basic, [:name, :email]
          end

          assert_equal @table_class.new.columns.map(&:id), [:id, :name, :email]
          assert_equal @table_class.new(column_group_id: :basic).columns.map(&:id), [:name, :email]
        end

        test "column types" do
          @table_class.class_eval do
            column_type :string do |value|
              "String: #{value.to_s}"
            end

            columns do |t|
              t.string :id
            end
          end

          id_column = @table_class.find_column(:id)
          record = Record.new(id: 1, name: "John")

          assert_equal "String: 1", @table_class.new.column_cell_html(record, id_column)
        end
      end
    end
  end
end
