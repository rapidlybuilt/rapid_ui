# frozen_string_literal: true

require "view_component"

module RapidUI
  module Datatable
    module Extensions
      module SelectFilters
        extend ActiveSupport::Concern
        Definition = Struct.new(:filter_id, :choices, :filter, :param_name, :skip_method_name, keyword_init: true)

        included do
          include Support::HasPersistentParams
          include Support::HasStimulusController
          include Rows
        end

        def select_filter_value(filter_id)
          params[select_filter_param(filter_id)]
        end

        def select_filter_param(filter_id)
          send(:"select_filter_#{filter_id}_param_name")
        end

        module ClassMethods
          def select_filter(filter_id, choices:, filter:, param_name: :"#{filter_id}_filter", skip_method_name: :"skip_#{filter_id}_filter")
            definition = Definition.new(
              filter_id:,
              choices:,
              filter:,
              param_name:,
              skip_method_name:,
            )

            class_attribute skip_method_name, default: false
            alias_method :"skip_#{filter_id}_filter?", skip_method_name

            name = :"select_filter_#{filter_id}_param_name"
            define_method name do
              definition.param_name
            end
            persistent_param name

            register_filter :"select_filter_#{definition.filter_id}", prepend: true do |table, scope|
              next if table.send(definition.skip_method_name)

              value = table.select_filter_value(definition.filter_id)
              definition.filter.call(scope, value) if value
            end

            if respond_to?(:register_control)
              register_control :"#{filter_id}_filter", ->(**kwargs) do
                build(Component, definition, table:, **kwargs)
              end
            end
          end
        end

        class Component < ApplicationComponent
          attr_reader :definition
          attr_reader :table

          with_options to: :definition do
            delegate :filter_id
            delegate :choices
          end

          def initialize(definition, table:, **kwargs)
            super(**kwargs)

            @definition = definition
            @table = table
          end

          def call
            select_tag param_name,
              options_for_select(build_choices, selected_url),
              class: "datatable-select datatable-filter-select",
              autocomplete: "off",
              data: {
                action: table.stimulus_controller.action("change", "navigateFromSelect"),
                turbo_stream: table.stimulus_controller.turbo_stream?,
              }
          end

          private

          def param_name
            table.param_name(table.select_filter_param(filter_id))
          end

          def selected_value
            table.select_filter_value(filter_id)
          end

          def build_choices
            param = table.select_filter_param(filter_id)
            all_option = [ all_label, table.component_path(param => nil) ]
            filter_options = choices.call(table.unfiltered_rows).map do |opt|
              # TODO: place page param back to 1 (since filtering completely changes the objects)
              [ opt, table.component_path(param => opt) ]
            end

            [ all_option ] + filter_options
          end

          def selected_url
            table.component_path(table.select_filter_param(filter_id) => selected_value)
          end

          def all_label
            t("all", filter: filter_id.to_s.humanize.pluralize)
          end
        end
      end
    end
  end
end
