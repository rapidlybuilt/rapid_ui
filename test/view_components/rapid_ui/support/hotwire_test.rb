# frozen_string_literal: true

require_relative "../view_component_test_case"

module RapidUI
  module Support
    class HotwireTest < ViewComponent::TestCase
      class Host
        include RapidUI::Support::Hotwire
      end

      setup do
        @host = Host.new
      end

      test "stimulus_controller and skip_turbo are settable via delegation" do
        @host.stimulus_controller = "datatable"
        @host.skip_turbo = true
        assert_equal "datatable", @host.stimulus_controller
        assert_equal true, @host.skip_turbo?
      end

      test "turbo_stream? is true when skip_turbo is false" do
        @host.skip_turbo = false
        assert_equal true, @host.hotwire.turbo_stream?
      end

      test "turbo_stream? is false when skip_turbo is true" do
        @host.skip_turbo = true
        assert_equal false, @host.hotwire.turbo_stream?
      end

      test "turbo_stream returns value when enabled, nil when disabled" do
        @host.skip_turbo = false
        assert @host.hotwire.turbo_stream
        assert_equal true, @host.hotwire.turbo_stream?

        @host.skip_turbo = true
        assert_nil @host.hotwire.turbo_stream
        assert_equal false, @host.hotwire.turbo_stream?
      end

      test "stimulus_action returns action->controller#method format" do
        @host.stimulus_controller = "datatable"
        assert_equal "click->datatable#refresh", @host.stimulus_action("click", "refresh")
      end

      test "stimulus_action raises AdapterRequiredError when controller blank" do
        @host.stimulus_controller = nil
        error = assert_raises(RapidUI::AdapterRequiredError) { @host.stimulus_action("click", "refresh") }
        assert_includes error.message, "stimulus_controller"
      end

      test "stimulus_action raises when controller is empty string" do
        @host.stimulus_controller = ""
        assert_raises(RapidUI::AdapterRequiredError) { @host.stimulus_action("click", "refresh") }
      end

      test "stimulus_actions joins pairs into space-separated action strings" do
        @host.stimulus_controller = "datatable"
        result = @host.stimulus_actions("change", "toggleSelections", "change", "togglePerform")
        assert_equal "change->datatable#toggleSelections change->datatable#togglePerform", result
      end

      test "stimulus_target returns controller-target format" do
        @host.stimulus_controller = "datatable"
        assert_equal "datatable-target", @host.stimulus_target
      end

      test "stimulus_target raises AdapterRequiredError when controller blank" do
        @host.stimulus_controller = nil
        assert_raises(RapidUI::AdapterRequiredError) { @host.stimulus_target }
      end

      test "merge merges options with turbo_stream and extra data" do
        @host.skip_turbo = false
        result = @host.hotwire.merge({}, foo: "bar")
        assert_equal true, result[:turbo_stream]
        assert_equal "bar", result[:foo]
      end

      test "merge uses custom turbo_stream when passed" do
        @host.skip_turbo = false
        result = @host.hotwire.merge({}, turbo_stream: "custom-value", baz: "qux")
        assert_equal "custom-value", result[:turbo_stream]
        assert_equal "qux", result[:baz]
      end

      test "merge merges data via RapidUI.merge_data" do
        @host.skip_turbo = true
        result = @host.hotwire.merge({ controller: "existing" }, other: "value")
        assert_equal "existing", result[:controller]
        assert_equal "value", result[:other]
        assert_nil result[:turbo_stream]
      end

      test "hotwire returns same Data instance" do
        assert_same @host.hotwire, @host.hotwire
      end
    end
  end
end
