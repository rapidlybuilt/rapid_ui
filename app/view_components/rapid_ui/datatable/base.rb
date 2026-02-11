# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < ApplicationComponent
      include Controls::Container

      include Columns
      include Export
      include Search
      include Sorting

      include ColumnTypes

      include BulkActions
      include Pagination
      include SelectFilter::Container

      attr_reader :base_scope

      with_options to: :records do
        delegate :empty?
        delegate :any?
      end

      renders_one :header, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(self.class.controls_class, table: self, **kwargs, class: RapidUI.merge_classes("datatable-footer", kwargs[:class]))
      end

      def initialize(base_scope, tag_name: :div, id:, data: {}, factory:, **options, &block)
        super(tag_name:, id:, data:, factory:, class: options[:class])

        ensure_base_scope_or_block(base_scope, block)

        @base_scope = base_scope

        self.stimulus_controller = "datatable"
        self.id ||= self.class.name.underscore.gsub("/", "_") if self.class.name
        self.table_name = self.class.table_name

        apply_initializers(options.except(:class))
      end

      def records
        @records ||= apply_filters(@base_scope)
      end

      def reload
        @records = nil
      end

      def empty_message
        t("empty_message")
      end

      def dom_id(record)
        super if record.respond_to?(:to_key)
      end

      def record_id(record)
        record.id
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

      private

      def ensure_base_scope_or_block(base_scope, block)
        raise ArgumentError, "records or block is required" if base_scope.nil? && block.nil?
        raise ArgumentError, "records and block cannot be used together" if base_scope.present? && block.present?
      end
    end
  end
end
