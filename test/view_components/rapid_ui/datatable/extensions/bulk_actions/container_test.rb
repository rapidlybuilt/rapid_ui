require_relative "../../../view_component_test_case"

module RapidUI
  module Datatable
    module Extensions
      module BulkActions
        class ContainerTest < ViewComponentTestCase
          described_class Container

          class BulkActionsTable < ExtensionSupport::TestComponent
            include BulkActions

            column :id
            column :name

            bulk_action :delete
            bulk_action :archive, label: "Archive Selected"

            def table_path(**options)
              "/#{options.to_query}"
            end
          end

          test "renders select and submit tags" do
            table = BulkActionsTable.new
            render_inline(build(table:))

            assert_selector "select[data-datatable-target='bulkActionSelect']" do
              assert_selector "option[value='delete']", text: "Delete"
            end
            assert_selector "input[type='submit']"
          end
        end
      end
    end
  end
end
