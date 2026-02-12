# frozen_string_literal: true

module RapidUI
  module Datatable
    module Support
      # The Params module helps tables access the request params and maintain state across requests.
      module Params
        extend ActiveSupport::Concern

        included do
          include RapidUI::Support::RegisterProcs
          include RapidUI::Support::Config
          include RapidUI::Support::HasParams

          # the action in which the table appears by default (not in response to a POST action)
          attr_accessor :action_name

          class_attribute :registered_param_config_attrs, default: []

          register_initializer :params, after: :config_attribute_defaults

          config_class! do
            attr_accessor :params
            attr_accessor :param_name
            attr_accessor :action
          end
        end

        # Gets the list of parameter names that have been registered for this table.
        #
        # @return [Array<String>] The registered parameter names
        def registered_param_names
          @registered_param_names ||= []
        end

        # Registers parameter names that should be preserved across requests.
        #
        # @param param_names [Array<String, Symbol>] The parameter names to register
        # @return [void]
        # @example
        #   register_param_name(:page, :sort, :per_page)
        def register_param_name(*param_names)
          @registered_param_names ||= []
          @registered_param_names += param_names
        end

        # Gets the registered parameters with optional overrides.
        #
        # @param param_overrides [Hash] Optional parameter overrides
        # @return [Hash] The registered parameters with any overrides applied
        # @example
        #   registered_params(page: 2, sort: "name")
        def registered_params(**param_overrides)
          if param_overrides.any?
            registered_params.merge(param_overrides)
          elsif params.is_a?(ActionController::Parameters)
            params.to_unsafe_h.slice(*registered_param_names)
          else
            params.slice(*registered_param_names)
          end
        end

        # Generates hidden form fields for all registered parameters.
        #
        # @param additional_params [Hash] Optional parameter overrides
        # @param except [Array<Symbol>] Optional parameters to exclude
        # @return [String] HTML string containing hidden input fields
        # @example
        #   hidden_fields_for_registered_params(additional_params: { page: 2 })
        #   # => '<input type="hidden" name="table[page]" value="2" />...'
        def hidden_fields_for_registered_params(additional_params: {}, except: [])
          params = registered_params(**additional_params)
          params = params.except(*except)

          params.map do |name, value|
            hidden_field_tag(param_name(name), value, id: nil)
          end.join.html_safe << hidden_field_tag("table", param_name || "", id: nil)
        end

      private

        def initialize_params(config)
          self.param_name = config.param_name
          self.full_params = config.params || {}
          self.action_name = config.action || full_params[:action]

          # Register param names declared via registers_param
          registered_param_config_attrs.each do |config_attr_name|
            param_value = config.send(config_attr_name)
            register_param_name(param_value) if param_value
          end
        end

        # Class methods for declaring param registrations.
        module ClassMethods
          # Defines a config attribute whose value is a param name that should be registered.
          # Combines config_attribute + registers_param into a single declaration.
          #
          # @param name [Symbol] The attribute name
          # @param options [Hash] Options passed to config_attribute (default:, instance_reader:, boolean:)
          # @return [void]
          #
          # @example
          #   config_attribute_param :search_param, default: :q
          #   config_attribute_param :page_param, default: :page
          def config_attribute_param(name, **options)
            config_attribute(name, **options)
            registers_param(name)
          end

          # Declares that a config attribute's value should be registered as a param name.
          # The param registration happens automatically in the :params initializer.
          #
          # @param config_attr_names [Array<Symbol>] The config attribute names whose values are param names
          # @return [void]
          #
          # @example
          #   registers_param :search_param
          #   registers_param :page_param, :per_page_param
          def registers_param(*config_attr_names)
            self.registered_param_config_attrs += config_attr_names
          end
        end
      end
    end
  end
end
