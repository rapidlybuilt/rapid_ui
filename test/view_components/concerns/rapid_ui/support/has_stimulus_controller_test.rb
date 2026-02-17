# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Support
    class HasStimulusControllerTest < ViewComponent::TestCase
      class Host
        include RapidUI::Support::HasStimulusController
        self.stimulus_controller = "my_controller"
      end

      setup do
        @host = Host.new
        @controller = @host.stimulus_controller
      end

      test "stimulus_controller name defaults to class name" do
        assert_equal "my_controller", @controller.name
      end

      test "stimulus_action returns action->controller#method format" do
        assert_equal "click->my_controller#refresh", @controller.action("click", "refresh")
      end

      test "stimulus_action raises AdapterRequiredError when controller blank" do
        @controller.name = nil
        error = assert_raises(ArgumentError) { @controller.action("click", "refresh") }
        assert_equal "stimulus controller name isn't set", error.message
      end

      test "stimulus_action raises when controller is empty string" do
        @controller.name = ""
        assert_raises(ArgumentError) { @controller.action("click", "refresh") }
      end

      test "stimulus_actions joins pairs into space-separated action strings" do
        result = @controller.actions("change", "toggleSelections", "change", "togglePerform")
        assert_equal "change->my_controller#toggleSelections change->my_controller#togglePerform", result
      end

      test "stimulus_target returns controller-target format" do
        assert_equal "my_controller-target", @controller.target
      end

      test "stimulus_target raises AdapterRequiredError when controller blank" do
        @controller.name = nil
        assert_raises(ArgumentError) { @controller.target }
      end

      test "merge merges options with turbo_stream and extra data" do
        @controller.skip_turbo = false
        result = @controller.merge({}, foo: "bar")
        assert_equal true, result[:turbo_stream]
        assert_equal "bar", result[:foo]
      end

      test "merge uses custom turbo_stream when passed" do
        @controller.skip_turbo = false
        result = @controller.merge({}, turbo_stream: "custom-value", baz: "qux")
        assert_equal "custom-value", result[:turbo_stream]
        assert_equal "qux", result[:baz]
      end

      test "merge merges data via RapidUI.merge_data" do
        @controller.skip_turbo = true
        result = @controller.merge({ controller: "existing" }, other: "value")
        assert_equal "existing", result[:controller]
        assert_equal "value", result[:other]
        assert_nil result[:turbo_stream]
      end
    end
  end
end
