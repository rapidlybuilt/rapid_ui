module RapidUI
  module Support
    module HasParams
      extend ActiveSupport::Concern

      included do
        class_attribute :param_name, instance_reader: false
        attr_accessor :full_params
      end

      # Gets the parameters for this table, handling nested parameter names.
      #
      # @return [Hash, ActionController::Parameters] The parameters for this table
      def params
        (_param_name ? full_params&.dig(_param_name) : full_params) || {}
      end

      # Generates a unique ID for form elements, optionally prefixed with the table's param name.
      #
      # @param name [String, Symbol] The base name for the ID
      # @return [String] The generated ID
      # @example
      #   id_for(:search) # => "search" or "table_search" if param_name is "table"
      def id_for(name)
        if _param_name
          "#{_param_name}_#{name}"
        else
          name
        end
      end

      # Generates a parameter name, optionally nested under the table's param name.
      #
      # @param nested_name [String, Symbol, nil] The nested parameter name (optional)
      # @return [String] The generated parameter name
      # @example
      #   param_name(:page) # => "page" or "table[page]" if param_name is "table"
      #   param_name        # => nil or "table" if param_name is "table"
      def param_name(nested_name = nil)
        if nested_name && _param_name
          "#{_param_name}[#{nested_name}]"
        elsif nested_name
          nested_name
        else
          _param_name
        end
      end

      private

      def _param_name
        defined?(@param_name) ? @param_name : self.class.param_name
      end
    end
  end
end
