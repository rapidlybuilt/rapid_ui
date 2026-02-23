require "test_helper"

module RapidUI
  module Datatable
    class BaseTest < ViewComponentTestCase
      User = Struct.new(:id, :name)

      class TestTable < RapidUI::Datatable::Base
        include Adapters::Array
        include ExtensionSupport::PathsHelper

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
            h.with_tag(:button, "Test Button")
          end
        end

        assert_selector "div.datatable-header button", text: "Test Button"
      end

      test "renders the footer controls" do
        render_inline build(@records, id: "my-table") do |t|
          t.with_footer do |f|
            f.with_tag(:button, "Test Button")
          end
        end

        assert_selector "div.datatable-footer button", text: "Test Button"
      end

      test "renders an empty message when the table is empty" do
        render_inline build([], id: "my-table")
        assert_selector ".datatable-empty-message", text: "No records found"
      end

      test "delays the execution of rows as procs" do
        p = -> { @ran = true ; @records }

        component = build(p, id: "my-table")
        assert_nil @ran
        render_inline component
        assert_equal true, @ran
        assert_selector "tr#user_1"
        assert_selector "tr#user_2"
      end

      test "raising an error when given an unknown argument name" do
        assert_raises ArgumentError do
          build(@records, id: "my-table", unknown: "argument")
        end
      end
    end
  end
end
