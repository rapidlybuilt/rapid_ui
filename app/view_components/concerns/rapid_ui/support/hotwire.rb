module RapidUI
  module Support
    # The Hotwire module provides integration with Hotwire (Turbo and Stimulus) for
    # RapidUI. It handles Turbo Stream responses and generates Stimulus controller
    # actions and targets.
    module Hotwire
      extend ActiveSupport::Concern

      included do
        attr_writer :hotwire

        class_attribute :stimulus_controller, instance_accessor: false

        with_options to: :hotwire do
          delegate :stimulus_controller
          delegate :stimulus_controller=

          delegate :stimulus_action
          delegate :stimulus_actions
          delegate :stimulus_target

          delegate :skip_turbo?
          delegate :skip_turbo=

          delegate :turbo_stream?
          delegate :turbo_stream
        end
      end

      def hotwire
        @hotwire ||= Data.new(stimulus_controller: self.class.stimulus_controller)
      end

      class Data
        attr_accessor :stimulus_controller

        attr_accessor :skip_turbo
        alias_method :skip_turbo?, :skip_turbo

        def initialize(stimulus_controller: nil)
          @stimulus_controller = stimulus_controller
        end

        # Checks if Turbo Stream responses should be enabled.
        #
        # @return [Boolean] True if Turbo Stream is enabled, false otherwise
        def turbo_stream?
          !skip_turbo?
        end

        # Returns the Turbo Stream value for data attributes, or nil if disabled.
        #
        # @return [String, nil] The Turbo Stream value or nil if disabled
        def turbo_stream
          turbo_stream? || nil
        end

        # Generates a Stimulus action string in the format "action->controller#method".
        #
        # @param action [String] The DOM event (e.g., "click", "change")
        # @param js_method [String] The JavaScript method to call on the controller
        # @return [String] The formatted Stimulus action string
        def stimulus_action(action, js_method)
          ensure_stimulus_controller!

          "#{action}->#{stimulus_controller}##{js_method}"
        end

        # Generates multiple Stimulus actions from pairs of action/method arguments.
        #
        # @param actions [Array<String>] Array of action/method pairs
        # @return [String] Space-separated Stimulus action strings
        # @example
        #   stimulus_actions("change", "toggleSelections", "change", "togglePerform")
        #   # => "change->rapid-table#toggleSelections change->rapid-table#togglePerform"
        def stimulus_actions(*actions)
          actions.in_groups_of(2).map do |action, js_method|
            stimulus_action(action, js_method)
          end.join(" ")
        end

        # Generates the Stimulus target attribute name for this table.
        #
        # @return [String] The Stimulus target attribute name
        def stimulus_target
          ensure_stimulus_controller!

          "#{stimulus_controller}-target"
        end

        # Merges Hotwire data attributes with existing options.
        #
        # @param options [Hash] The existing HTML data options
        # @param turbo_stream [String, nil] The Turbo Stream value (defaults to self.turbo_stream)
        # @param data [Hash] Additional data attributes to merge
        # @return [Hash] The merged data attributes
        def merge(options = {}, turbo_stream: self.turbo_stream, **data)
          RapidUI.merge_data(options, data).merge(turbo_stream:)
        end

        private

        # Ensures the Stimulus controller is set.
        #
        # @raise [AdapterRequiredError] If the Stimulus controller is not set
        def ensure_stimulus_controller!
          raise AdapterRequiredError, "stimulus_controller is required" if stimulus_controller.blank?
        end
      end
    end
  end
end
