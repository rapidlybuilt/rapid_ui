# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class HotwireTest < ViewComponent::TestCase
        class TestTable
          include Hotwire
        end

        setup do
          @table = TestTable.new
        end

        test "stimulus_controller and skip_turbo are settable" do
          @table.stimulus_controller = "datatable"
          @table.skip_turbo = true
          assert_equal "datatable", @table.stimulus_controller
          assert_equal true, @table.skip_turbo
          assert_equal true, @table.skip_turbo?
        end

        test "turbo_stream returns value when enabled, nil when disabled" do
          @table.skip_turbo = false
          assert @table.turbo_stream
          assert_equal true, @table.turbo_stream?

          @table.skip_turbo = true
          assert_nil @table.turbo_stream
          assert_equal false, @table.turbo_stream?
        end

        test "stimulus_action format" do
          @table.stimulus_controller = "datatable"
          assert_equal "click->datatable#refresh", @table.send(:stimulus_action, "click", "refresh")
        end

        test "stimulus_action raises when controller blank" do
          @table.stimulus_controller = nil
          error = assert_raises(RapidUI::ExtensionRequiredError) { @table.send(:stimulus_action, "click", "refresh") }
          assert_includes error.message, "stimulus_controller"
        end

        test "stimulus_actions joins pairs" do
          @table.stimulus_controller = "datatable"
          result = @table.send(:stimulus_actions, "change", "toggleA", "click", "submit")
          assert_equal "change->datatable#toggleA click->datatable#submit", result
        end

        test "stimulus_target format" do
          @table.stimulus_controller = "datatable"
          assert_equal "datatable-target", @table.send(:stimulus_target)
        end

        test "hotwire_data merges data when options has no data key" do
          result = @table.send(:hotwire_data, {}, foo: "bar")
          assert_equal({ turbo_stream: true, foo: "bar" }, result)
        end

        test "hotwire_data raises when options has data key" do
          error = assert_raises(NotImplementedError) { @table.send(:hotwire_data, { data: {} }) }
          assert_includes error.message, "not implemented"
        end
      end
    end
  end
end
