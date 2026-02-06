# frozen_string_literal: true

require "view_component"

module RapidUI
  module Datatable
    # TODO: pull into rapid_table/ext
    class SelectFilter < ApplicationComponent
      attr_reader :filter_id
      attr_reader :options_proc
      attr_reader :filter_proc
      attr_reader :table

      def initialize(filter_id:, options:, filter:, table:, **kwargs)
        super(**kwargs)

        @filter_id = filter_id
        @options_proc = options
        @filter_proc = filter
        @table = table
      end

      def call
        select_tag param_name,
          options_for_select(choices, selected_url),
          class: "datatable-select datatable-filter-select",
          autocomplete: "off",
          data: {
            action: table.send(:stimulus_action, "change", "navigateFromSelect"),
            turbo_stream: table.turbo_stream
          }
      end

      private

      def param_name
        table.param_name(table.select_filter_param(filter_id))
      end

      def selected_value
        table.select_filter_value(filter_id)
      end

      def choices
        param = table.select_filter_param(filter_id)
        all_option = [all_label, table.table_path(param => nil)]
        filter_options = options_proc.call(table.base_scope).map do |opt|
          [opt, table.table_path(param => opt)]
        end

        [all_option] + filter_options
      end

      def selected_url
        table.table_path(table.select_filter_param(filter_id) => selected_value)
      end

      def all_label
        I18n.t("rapid_ui.datatable.select_filter.all", filter: filter_id.to_s.humanize.pluralize)
      end

      module Container
        extend ActiveSupport::Concern

        included do
          register_initializer :select_filters
          register_filter :select_filters
        end

        module ClassMethods
          def select_filter(filter_id, options:, filter:)
            select_filter_definitions << {
              filter_id: filter_id,
              options: options,
              filter: filter
            }
          end

          def select_filter_definitions
            @select_filter_definitions ||= begin
              inherited = if superclass.respond_to?(:select_filter_definitions)
                            superclass.select_filter_definitions.dup
                          else
                            []
                          end
              inherited
            end
          end
        end

        def select_filter_value(filter_id)
          params[select_filter_param(filter_id)]
        end

        def select_filter_param(filter_id)
          :"#{filter_id}_filter"
        end

      private

        def initialize_select_filters(_config)
          self.class.select_filter_definitions.each do |definition|
            filter_id = definition[:filter_id]
            register_param_name(select_filter_param(filter_id))

            build_select_filter(filter_id, options: definition[:options], filter: definition[:filter])
          end
        end

        def filter_select_filters(scope)
          self.class.select_filter_definitions.inject(scope) do |filtered_scope, definition|
            filter_id = definition[:filter_id]
            value = select_filter_value(filter_id)

            if value.present?
              definition[:filter].call(filtered_scope, value)
            else
              filtered_scope
            end
          end
        end
      end
    end
  end
end
