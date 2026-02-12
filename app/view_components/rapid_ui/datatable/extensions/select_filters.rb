# frozen_string_literal: true

require "view_component"

module RapidUI
  module Datatable
    module Extensions
      module SelectFilters
        extend ActiveSupport::Concern

        Definition = Struct.new(:filter_id, :options, :filter)

        included do
          include RapidUI::Support::Config
          include Support::Params
          include RapidUI::Support::Hotwire
          include Rows

          self.stimulus_controller ||= "datatable"

          register_initializer :select_filters
          register_filter :select_filters

          class_attribute :select_filter_definitions, default: []

          if respond_to?(:register_control)
            register_control :select_filter, ->(definition, **kwargs) do
              if definition.is_a?(Symbol)
                definition = table.class.select_filter_definitions.find { |d| d.filter_id == definition }
              end

              build(
                Component,
                filter_id: definition.filter_id,
                options: definition.options,
                filter: definition.filter,
                table:,
                hotwire:,
                **kwargs,
              )
            end

            controls_class.include(ControlsHelper)
          end
        end

        def select_filter_value(filter_id)
          params[select_filter_param(filter_id)]
        end

        def select_filter_param(filter_id)
          :"#{filter_id}_filter"
        end

        def skip_select_filters?
          select_filter_definitions.empty?
        end

        module ClassMethods
          def select_filter(filter_id, options:, filter:)
            self.select_filter_definitions += [ Definition.new(filter_id, options, filter) ]
          end
        end

        module ControlsHelper
          def build_select_filters
            table.class.select_filter_definitions.each do |definition|
              build_select_filter(definition)
            end
          end
        end

        private

        def initialize_select_filters(_config)
          select_filter_definitions.each do |definition|
            filter_id = definition.filter_id
            register_param_name(select_filter_param(filter_id))
          end
        end

        def filter_select_filters(scope)
          select_filter_definitions.inject(scope) do |filtered_scope, definition|
            filter_id = definition.filter_id
            value = select_filter_value(filter_id)

            if value.present?
              definition.filter.call(filtered_scope, value)
            else
              filtered_scope
            end
          end
        end

        class Component < ApplicationComponent
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
                turbo_stream: table.turbo_stream,
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
            all_option = [ all_label, table.table_path(param => nil) ]
            filter_options = options_proc.call(table.unfiltered_rows).map do |opt|
              # TODO: place page param back to 1 (since filtering completely changes the objects)
              [ opt, table.table_path(param => opt) ]
            end

            [ all_option ] + filter_options
          end

          def selected_url
            table.table_path(table.select_filter_param(filter_id) => selected_value)
          end

          def all_label
            t("all", filter: filter_id.to_s.humanize.pluralize)
          end
        end
      end
    end
  end
end
