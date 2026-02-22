# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < ApplicationComponent
      include Support::Loaders
      include Support::HasTableTag
      include Controls

      controls_placement :header, %i[search_field_form]
      controls_placement :footer, %i[per_page pagination]

      include Columns
      include ColumnTypes
      include Pagination
      include Rows
      include Search
      include Sorting

      renders_one :header, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-controls datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-controls datatable-footer", kwargs[:class]))
      end

      def initialize(unfiltered_rows, tag_name: :div, id:, data: {}, factory:, **options)
        raise ArgumentError, "unfiltered_rows is required" unless unfiltered_rows

        super(tag_name:, id:, data:, factory:, class: options[:class])

        self.unfiltered_rows = unfiltered_rows
        self.id = id

        columns_options = options.slice(:columns, :column_ids, :column_group_id, :except, :only)
        self.columns = build_columns(**columns_options) || raise(ArgumentError, "columns must be specified")

        options.except(:class, *columns_options.keys).each do |key, value|
          name = "#{key}="
          raise ArgumentError, "unknown argument: #{key}" unless respond_to?(name)
          send(name, value)
        end
      end

      def reload
        reset_rows
      end

      def before_render
        ensure_controls_built
      end

      # TODO: make this a polymorphic single slot
      def empty_message
        t("empty_message")
      end
    end
  end
end
