require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    class BaseTest < ViewComponentTestCase
      User = Struct.new(:id, :name)

      class TestTable < RapidUI::Datatable::Base
        include Adapters::Array

        columns do |t|
          t.string :id
          t.string :name
        end

        # TODO: better way to test this / default behavior?
        def dom_id(record)
          "user_#{record.id}"
        end
      end

      described_class TestTable

      setup do
        @records = [User.new(1, "John"), User.new(2, "Jane")]
      end

      test "renders the main container with the default stimulus controller" do
        render_inline build(@records, id: "my-table")

        assert_selector "div#my-table[data-controller='datatable']"
      end

      test "renders the column headers" do
        render_inline build(@records, id: "my-table")

        assert_selector "thead tr th[scope='col']", text: "Id"
        assert_selector "thead tr th[scope='col']", text: "Name"
      end

      test "renders a row for each record" do
        render_inline build(@records, id: "my-table")

        assert_selector "tr#user_1"
        assert_selector "tr#user_2"
      end

      test "full example run" do
        table = build(@records, id: "my-table")

        table.build_header do |header|
          header.build_tag("My Table", tag_name: :h2, class: "text-lg")

          header.build_bulk_actions(table:, class: "datatable-bulk-actions-select-container")

          header.build_filters(table:) do |filters|
            filters.build_select_filter(
              "name",
              options: ->(scope) { scope.map(&:name).uniq.sort },
              filter: ->(scope, value) { scope.keep_if { |record| record.name == value } },
            )

            filters.build_search_field_form
          end
        end

        table.build_footer do |footer|
          footer.build_per_page(table:)
          footer.build_pagination(table:)
          footer.build_exports(table:)
        end
      end
    end
  end
end
