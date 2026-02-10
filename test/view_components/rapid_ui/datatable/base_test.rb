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
        @records = [ User.new(1, "John"), User.new(2, "Jane") ]
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

      test "renders the header controls" do
        render_inline build(@records, id: "my-table") do |t|
          t.with_header do |h|
            h.with_button("Test Button")
          end
        end

        assert_selector "div.datatable-header button", text: "Test Button"
      end

      test "renders the footer controls" do
        render_inline build(@records, id: "my-table") do |t|
          t.with_footer do |f|
            f.with_button("Test Button")
          end
        end

        assert_selector "div.datatable-footer button", text: "Test Button"
      end
    end
  end
end
