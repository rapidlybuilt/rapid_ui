# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < ApplicationComponent
      # TODO: have the concern that uses these include them
      include Support::ExtendableClass
      include Support::Hotwire
      include Support::Params
      include Support::ConfigAttribute

      include Columns
      include Export
      include Search
      include Sorting

      include ColumnTypes

      include BulkActions
      include Pagination
      include SelectFilter::Container

      attr_reader :base_scope
      attr_reader :config

      attr_accessor :table_name

      with_options to: :records do
        delegate :empty?
        delegate :any?
      end

      renders_one :header, ->(**kwargs) do
        build(Controls, table: self, **kwargs, class: RapidUI.merge_classes("datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(Controls, table: self, **kwargs, class: RapidUI.merge_classes("datatable-footer", kwargs[:class]))
      end

      def initialize(base_scope, **kwargs, &block)
        ensure_base_scope_or_block(base_scope, block)

        self.stimulus_controller = "datatable"
        super(*kwargs)
        self.id ||= self.class.name.underscore.gsub("/", "_") if self.class.name
        self.table_name = self.class.table_name

        apply_initializers(options)
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

      def record_id(_record)
        raise ExtensionRequiredError
      end

      def table_path(view_context: self, format: nil, **options)
        options = options.reverse_merge(registered_params)
        if param_name
          view_context.url_for(action: action_name, table: param_name, param_name => options, format:)
        else
          view_context.url_for(action: action_name, format:, table: "", **options)
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

      def t(key)
        self.class.t(key, table_name:)
      end

      def ensure_base_scope_or_block(base_scope, block)
        raise ArgumentError, "records or block is required" if base_scope.nil? && block.nil?
        raise ArgumentError, "records and block cannot be used together" if base_scope.present? && block.present?
      end

      class << self
        def t(key, table_name:)
          RapidUI::Datatable.t(key, table_name:)
        end

        def table_name
          name&.underscore
        end
      end
    end
  end
end
