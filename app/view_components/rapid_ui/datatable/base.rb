# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < ApplicationComponent
      include Controls::Container

      include Columns
      include Rows
      include Export
      include Search
      include Sorting

      include ColumnTypes

      include BulkActions
      include Pagination
      include SelectFilter::Container

      renders_one :header, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-footer", kwargs[:class]))
      end

      def initialize(unfiltered_rows, tag_name: :div, id:, data: {}, factory:, **options)
        super(tag_name:, id:, data:, factory:, class: options[:class])

        self.unfiltered_rows = unfiltered_rows || raise(ArgumentError, "unfiltered_rows is required")
        self.stimulus_controller = "datatable"
        self.id ||= self.class.name.underscore.gsub("/", "_") if self.class.name

        apply_initializers(options.except(:class))
      end

      def reload
        reset_rows
      end

      # TODO: make this a polymorphic single slot
      def empty_message
        t("empty_message")
      end

      def table_path(view_context: nil, format: nil, **options)
        options = options.reverse_merge(registered_params)
        if param_name
          (view_context || helpers).url_for(action: action_name, table: param_name, param_name => options, format:)
        else
          (view_context || helpers).url_for(action: action_name, format:, table: "", **options)
        end
      end

      def dynamic_data
        # TODO: use hotwire_data
        merge_data(
          data,
          ({ controller: stimulus_controller } if stimulus_controller.present?),
        )
      end
    end
  end
end
