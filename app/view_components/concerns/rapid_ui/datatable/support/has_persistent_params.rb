# frozen_string_literal: true

module RapidUI
  module Datatable
    module Support
      # The Params module helps tables access the request params and maintain state across requests.
      module HasPersistentParams
        extend ActiveSupport::Concern

        included do
          include RapidUI::Support::HasParams

          # the action in which the table appears by default (not in response to a POST action)
          attr_accessor :action_name

          class_attribute :persistent_param_name_methods, default: [], instance_accessor: false
        end

        # Gets the list of parameter names that have been registered for this table.
        #
        # @return [Array<String>] The registered parameter names
        def persistent_param_names
          @persistent_param_names ||= self.class.persistent_param_name_methods.map do |attr|
            send(attr)
          end
        end

        # Registers parameter names that should be preserved across requests.
        #
        # @param param_names [Array<String, Symbol>] The parameter names to register
        # @return [void]
        # @example
        #   persist_param_name(:page, :sort, :per_page)
        def persist_param_name(*param_names)
          persistent_param_names.concat(param_names)
        end

        # Gets the registered parameters with optional overrides.
        #
        # @param param_overrides [Hash] Optional parameter overrides
        # @return [Hash] The registered parameters with any overrides applied
        # @example
        #   persistent_params(page: 2, sort: "name")
        def persistent_params(**param_overrides)
          if param_overrides.any?
            persistent_params.merge(param_overrides)
          elsif params.is_a?(ActionController::Parameters)
            params.to_unsafe_h.slice(*persistent_param_names)
          else
            params.slice(*persistent_param_names)
          end
        end

        # Generates hidden form fields for all registered parameters.
        #
        # @param additional_params [Hash] Optional parameter overrides
        # @param except [Array<Symbol>] Optional parameters to exclude
        # @return [String] HTML string containing hidden input fields
        # @example
        #   hidden_fields_of_persistent_params(additional_params: { page: 2 })
        #   # => '<input type="hidden" name="table[page]" value="2" />...'
        def hidden_fields_of_persistent_params(additional_params: {}, except: [])
          params = persistent_params(**additional_params)
          params = params.except(*except)

          params.map do |name, value|
            hidden_field_tag(param_name(name), value, id: nil)
          end.join.html_safe << hidden_field_tag("table", param_name || "", id: nil)
        end

        # Generates a path for the component.
        #
        # @param view_context [ActionView::Base, nil] The view context to use
        # @param format [String, nil] The format to use
        # @param options [Hash] The options to use
        # @return [String] The generated path
        # @example
        #   component_path(page: 2)
        #   # => "/users?component=&sort=name&page=2"
        def component_path(view_context: nil, format: nil, **options)
          options = options.reverse_merge(persistent_params)
          if param_name
            (view_context || helpers).url_for(action: action_name, component: param_name, param_name => options, format:)
          else
            (view_context || helpers).url_for(action: action_name, format:, component: "", **options)
          end
        end

        # Class methods for declaring param registrations.
        module ClassMethods
          # Declares that a config attribute's value should be registered as a param name.
          # The param registration happens automatically in the :params initializer.
          #
          # @param config_attr_names [Array<Symbol>] The config attribute names whose values are param names
          # @return [void]
          #
          # @example
          #   persistent_param :search_param
          #   persistent_param :page_param, :per_page_param
          def persistent_param(*config_attr_names)
            self.persistent_param_name_methods.concat(config_attr_names)
          end
        end
      end
    end
  end
end
