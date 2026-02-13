require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Pagination
      class PerPageSelectTest < ViewComponentTestCase
        described_class PerPageSelect

        class PaginationTable < ExtensionSupport::TestComponent
          include Pagination

          def call; ""; end

          def table_path(**options)
            "/?#{options.to_query}"
          end
        end

        test "per_page_select_tag renders select with options" do
          table = PaginationTable.new(full_params: { per: "100" })
          render_inline(build(table:))

          assert_selector "label" do
            assert_selector "select[name='per']" do
              assert_selector "option[value='/?page=1&per=25']", text: "25"
              assert_selector "option[value='/?page=1&per=25']", text: "25"
              assert_selector "option[value='/?page=1&per=100'][selected]", text: "100"
            end
          end
        end
      end
    end
  end
end
