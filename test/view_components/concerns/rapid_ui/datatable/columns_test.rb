require "test_helper"

module RapidUI
  module Datatable
    module ColumnsTest
      Record = Struct.new(:id, :name, :email, keyword_init: true)

      class BasicTest < ViewComponent::TestCase
        class TestTable < ExtensionSupport::TestComponent
          include Columns

          column :id
          column :name

          def call; end
        end

        class SubclassTable < TestTable
          column :email
        end

        setup do
          @table = TestTable.new
          render_inline @table
        end

        test "column_label returns a span with the column label" do
          assert_equal "Id", @table.column_label(:id).to_s
          assert_equal "Name", @table.column_label(:name).to_s
        end

        test "column_cell_html returns the cell value for the record and column" do
          record = Record.new(id: 1, name: "John")
          assert_equal 1, @table.column_cell_html(record, :id)
          assert_equal "John", @table.column_cell_html(record, :name)
        end

        test "subclass columns" do
          assert_equal :name, SubclassTable.find_column(:name).id
          assert_equal :email, SubclassTable.find_column(:email).id
        end

        test "finding columns" do
          assert_equal [ :id ], TestTable.find_columns!(column_ids: [ :id ]).map(&:id)

          assert_raises Columns::ColumnNotFoundError do
            TestTable.find_column!(:email)
          end
        end
      end

      class ColumnGroupTest < ViewComponent::TestCase
        class TestTable < ViewComponent::Base
          include Columns

          column :id
          column :name
          column :email

          column_group :basic, [ :name, :email ]
        end

        class SubclassTable < TestTable
          column :phone

          column_group :extended, [ :email, :phone ]
        end

        test "listing column groups" do
          assert_equal [ :default, :basic ], TestTable.column_groups.map(&:id)
          assert_equal [ :default, :basic, :extended ], SubclassTable.column_groups.map(&:id)
        end

        test "finding column groups" do
          assert_equal :basic, TestTable.find_column_group!(:basic).id
          assert_nil TestTable.find_column_group(:extended)

          assert_equal :basic, SubclassTable.find_column_group!(:basic).id
          assert_equal :extended, SubclassTable.find_column_group!(:extended).id
          assert_equal :default, SubclassTable.default_column_group.id

          assert_raises Columns::ColumnGroupNotFoundError do
            TestTable.find_column_group!(:extended)
          end
        end

        test "finding columns" do
          assert_equal [ :id, :name, :email ], TestTable.find_columns!(column_group_id: :default).map(&:id)
          assert_equal [ :name, :email ], TestTable.find_columns!(column_group_id: :basic).map(&:id)
        end
      end

      class ClassLevelTest < ViewComponent::TestCase
        setup do
          @record = Record.new(id: 1, name: "John")

          @table_class = Class.new(ViewComponent::Base) do
            include Columns

            def call; end
          end
        end

        test "defining and using column types" do
          @table_class.class_eval do
            column_type :string do |value|
              "String: #{value}"
            end

            columns do |t|
              t.string :id
            end
          end

          id_column = @table_class.find_column!(:id)
          assert_equal "String: 1", @table_class.new.column_cell_html(@record, id_column)
        end

        test "unknown column type" do
          assert_raises NoMethodError do
            @table_class.class_eval do
              columns do |t|
                t.string :id
              end
            end
          end
        end

        test "custom column value method" do
          @table_class.class_eval do
            column :id

            cell_value :id do |record|
              "Custom: #{record.id}"
            end
          end

          id_column = @table_class.find_column!(:id)
          assert_equal "Custom: 1", @table_class.new.column_cell_html(@record, id_column)
        end

        test "custom column html method" do
          @table_class.class_eval do
            column :id

            cell_value :id, :html do |record|
              "Custom: #{record.id}"
            end
          end

          id_column = @table_class.find_column!(:id)
          assert_equal "Custom: 1", @table_class.new.column_cell_html(@record, id_column)
        end
      end
    end
  end
end
