# frozen_string_literal: true

require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    class ControlsTest < ViewComponentTestCase
      described_class Controls

      class ControlsTable < ViewComponent::Base
        include Columns

        column :id
        column :name
      end

      test "renders nothing when no items are added" do
        table = ControlsTable.new
        render_inline(build(table: table))
        assert_no_selector "div"
      end

      test "renders wrapper div when items are added" do
        table = ControlsTable.new
        render_inline(build(table: table)) do |c|
          c.with_filters
        end
        assert_selector "div"
      end
    end
  end
end
