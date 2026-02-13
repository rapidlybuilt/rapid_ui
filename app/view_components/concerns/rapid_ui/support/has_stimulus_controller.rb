module RapidUI
  module Support
    # Generate actions and targets for this component's Stimulus controller
    # and consolidated toggling off turbo / turbo stream.
    module HasStimulusController
      extend ActiveSupport::Concern

      included do
        class_attribute :stimulus_controller, instance_accessor: false
      end

      def stimulus_controller
        @stimulus_controller ||= Data.new(self.class.stimulus_controller)
      end

      class Data
        attr_writer :name

        attr_accessor :skip_turbo
        alias_method :skip_turbo?, :skip_turbo

        def initialize(name)
          @name = name
        end

        def valid?
          @name.present?
        end

        def name
          @name.present? ? @name : raise(ArgumentError, "stimulus controller name isn't set")
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
        def action(action, js_method)
          "#{action}->#{name}##{js_method}"
        end

        # Generates multiple Stimulus actions from pairs of action/method arguments.
        #
        # @param actions [Array<String>] Array of action/method pairs
        # @return [String] Space-separated Stimulus action strings
        # @example
        #   actions("change", "toggleSelections", "change", "togglePerform")
        #   # => "change->rapid-table#toggleSelections change->rapid-table#togglePerform"
        def actions(*actions)
          actions.in_groups_of(2).map do |action, js_method|
            action(action, js_method)
          end.join(" ")
        end

        # Generates the Stimulus target attribute name for this table.
        #
        # @return [String] The Stimulus target attribute name
        def target
          "#{name}-target"
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
      end
    end
  end
end
