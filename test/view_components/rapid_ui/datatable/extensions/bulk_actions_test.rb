# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Extensions
      class BulkActionsTest < ViewComponent::TestCase
        include ExtensionSupport
        Record = Struct.new(:id, :name)

        class BulkActionsTable < ExtensionSupport::TestComponent
          include BulkActions

          column :id
          column :name

          bulk_action :delete
          bulk_action :archive, label: "Archive Selected"

          def row_id(record)
            record.id.to_s
          end
        end

        setup do
          @records = [ Record.new(1, "Alice"), Record.new(2, "Bob"), Record.new(3, "Carol") ]
        end

        test "show a subset of bulk actions" do
          table = BulkActionsTable.new(bulk_action_ids: [ :delete ])
          assert_equal 1, table.bulk_actions.size
          assert_equal :delete, table.bulk_actions.first.id
        end

        test "selected_bulk_action_record_ids returns ids from params" do
          table = BulkActionsTable.new(params: { ids: %w[1 3] })
          assert_equal %w[1 3], table.selected_bulk_action_record_ids
        end

        test "selected_bulk_action_record_ids returns empty array when no ids param" do
          table = BulkActionsTable.new
          assert_equal [], table.selected_bulk_action_record_ids
        end

        test "selected_bulk_action_record? returns whether record id is in selection" do
          table = BulkActionsTable.new(params: { ids: %w[1 3] })
          assert table.selected_bulk_action_record?(@records[0])
          assert_not table.selected_bulk_action_record?(@records[1])
          assert table.selected_bulk_action_record?(@records[2])
        end

        test "inserts bulk action column when bulk actions are enabled" do
          table = BulkActionsTable.new
          assert table.columns.first.respond_to?(:label_method)
          assert_equal :bulk_actions_select_all_check_box_tag, table.columns.first.label_method
          assert_equal :bulk_actions_select_one_check_box_tag, table.columns.first.html_cell_method
        end

        test "class bulk_action defines actions and find_bulk_action finds them" do
          assert_equal 2, BulkActionsTable.bulk_actions.size
          delete_action = BulkActionsTable.find_bulk_action(:delete)
          assert delete_action
          assert_equal :delete, delete_action.id
          archive_action = BulkActionsTable.find_bulk_action(:archive)
          assert_equal "Archive Selected", archive_action.label
        end

        test "find_bulk_action raises BulkActionNotFoundError for unknown id" do
          assert_raises(RapidUI::Datatable::Extensions::BulkActions::BulkActionNotFoundError) do
            BulkActionsTable.find_bulk_action(:nonexistent)
          end
        end

        test "bulk_actions control is registered" do
          klass = Class.new ViewComponent::Base do
            include Controls
            include BulkActions
          end

          assert_registers_control :bulk_actions, klass
        end
      end
    end
  end
end
