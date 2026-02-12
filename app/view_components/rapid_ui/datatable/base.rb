# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < ApplicationComponent
      include Support::Loaders
      include Support::HasTableTag
      include Controls

      include Columns
      include ColumnTypes
      include Pagination
      include Rows
      include Search
      include Sorting

      renders_one :header, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-footer", kwargs[:class]))
      end

      def initialize(unfiltered_rows, tag_name: :div, id:, data: {}, factory:, **options)
        raise ArgumentError, "unfiltered_rows is required" unless unfiltered_rows

        super(tag_name:, id:, data:, factory:, class: options[:class])

        self.unfiltered_rows = unfiltered_rows
        self.id = id

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
          (view_context || helpers).url_for(action: action_name, component: param_name, param_name => options, format:)
        else
          (view_context || helpers).url_for(action: action_name, format:, component: "", **options)
        end
      end
    end
  end
end
