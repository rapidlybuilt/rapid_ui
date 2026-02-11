# frozen_string_literal: true

module RapidUI
  module Datatable
    # The Search module provides functionality for searching and filtering table data in RapidUI datatable.
    # It exposes the following configuration options to RapidUI::Datatable::Base:
    #
    # @option config skip_search [Boolean] Whether to disable search functionality entirely
    # @option config search_param [Symbol] The parameter name for the search query (default: :q)
    module Search
      extend ActiveSupport::Concern

      included do
        include Support::Params
        include RapidUI::Support::I18n
        include Support::Hotwire
        include Rows

        config_attribute :skip_search, default: false
        config_attribute_param :search_param, default: :q

        register_filter :search, unless: :skip_search?

        if respond_to?(:register_control)
          register_control :search_field_form, ->(**kwargs) { build(Search::FieldForm, table:, **kwargs) }
        end
      end

      # Gets the current search query from the request parameters.
      #
      # @return [String, nil] The search query from params, or nil if not present
      def search_query
        params[search_param]
      end

      # Filters the scope based on the search query. Must be implemented by extensions.
      #
      # @param scope [Object] The scope to filter (e.g., ActiveRecord::Relation)
      # @return [Object] The filtered scope
      # @raise [AdapterRequiredError] If no extension provides this functionality
      def filter_search(_scope)
        raise AdapterRequiredError, "not implemented"
      end
    end
  end
end
