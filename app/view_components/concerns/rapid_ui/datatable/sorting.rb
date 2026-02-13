# frozen_string_literal: true

module RapidUI
  module Datatable
    # The Sorting module provides functionality for sorting table data in RapidUI datatable.
    # It exposes the following configuration options to RapidUI::Datatable::Base:
    #
    # @option config skip_sorting [Boolean] Whether to disable sorting functionality entirely
    # @option config sort_column_param [Symbol] The parameter name for the sort column (default: :sort)
    # @option config sort_order_param [Symbol] The parameter name for the sort order (default: :dir)
    # @option config sort_column [Symbol] The default column to sort by (default: nil)
    # @option config sort_order [String] The default sort order (default: "asc")
    #
    # Column-level sorting options:
    # @option config column.sortable [Boolean] Whether this column is sortable (default: false)
    # @option config column.sort_order [String] The default sort order for this column (default: "asc")
    #
    # @example Basic usage
    #   class MyTable < RapidUI::Datatable::Base
    #     self.skip_sorting = false
    #     self.sort_column = :name
    #     self.sort_order = :asc
    #   end
    #
    # @example With sorting disabled
    #   class MyTable < RapidUI::Datatable::Base
    #     self.skip_sorting = true
    #   end
    module Sorting
      extend ActiveSupport::Concern

      class_methods do
        with_options to: :default_column_group do
          delegate :sort_column
          delegate :sort_column=
          delegate :sort_order
          delegate :sort_order=
        end
      end

      included do
        include Columns
        include Rows
        include Support::HasPersistentParams
        include Support::HasStimulusController
        prepend InstanceOverrides

        class_attribute :skip_sorting, default: false
        class_attribute :sort_column_param, default: :sort
        class_attribute :sort_order_param, default: :dir

        persistent_param :sort_column_param
        persistent_param :sort_order_param

        register_filter :sorting, unless: :skip_sorting?

        attr_writer :sort_column
        attr_writer :sort_order

        column_class! do
          attr_reader :sortable
          attr_accessor :sort_order
          alias_method :sortable?, :sortable

          def sortable=(value)
            # sugar for setting sortable and the direction in one argument
            if %w[asc desc].include?(value)
              @sortable = true
              @sort_order = value
            else
              @sortable = value
            end
          end
        end

        # Add sort_column and sort_order to column groups if available
        column_group_class! do
          attr_accessor :sort_column, :sort_order
        end
      end

      # must be included AFTER Columns is included
      module InstanceOverrides
        def column_label(column)
          label = super(column)
          return label if skip_sorting? || !column.sortable?

          so = sort_column&.id == column.id ? reverse_sort_order(sort_order) : column.sort_order

          link_classes = [ "admin-table-header-cell-link" ]
          link_classes << "active" if sort_column&.id == column.id

          link_to(
            h(label) << sort_order_label(column),
            table_path(sort_column_param => column.id, sort_order_param => so),
            class: link_classes.join(" "),
            data: { turbo_stream: stimulus_controller.turbo_stream? },
          )
        end
      end

      def sort_column
        return @sort_column if defined?(@sort_column)

        sort_column_id = sort_column_param_value || column_group&.sort_column&.id || self.class.sort_column
        return unless sort_column_id.is_a?(Symbol) || sort_column_id.is_a?(String)

        @sort_column = find_sortable_column(sort_column_id)
        Rails.logger.warn("Sortable column #{sort_column_id} not found") unless @sort_column
        @sort_column
      end

      def sort_order
        return @sort_order if defined?(@sort_order)

        @sort_order = (sort_order_param_value || sort_column&.sort_order)&.to_s
        @sort_order = "asc" if @sort_order.blank?
        @sort_order
      end

      def filter_sorting(_scope)
        raise AdapterRequiredError
      end

      def sort_column_param_value
        value = params[sort_column_param]
        value = nil if value.present? && !find_sortable_column(value)
        value
      end

      def available_sort_orders
        %w[asc desc]
      end

      def reverse_sort_order(order)
        return "asc" if order == "desc"

        "desc"
      end

      def sort_order_param_value
        value = params[sort_order_param]
        value = nil if value && !available_sort_orders.include?(value)
        value
      end

      def sort_order_label(column)
        return "" unless column.sortable?

        tag.span(sort_order_icon_label(column), class: "admin-table-header-sort-order")
      end

      def sort_order_icon_label(column)
        return h("") unless column.sortable?

        if sort_column&.id != column.id
          "▲<br/>▼".html_safe
        elsif sort_order == "asc"
          "▲<br/>&nbsp;".html_safe
        else
          "&nbsp;<br/>▼".html_safe
        end
      end

      private

      def find_sortable_column(id)
        # Should it limit to only sorting on currently visible columns?
        # TODO: to_sym a memory leak?
        column = self.class.find_column!(id&.to_sym) if id
        column if column.sortable?
      end
    end
  end
end
