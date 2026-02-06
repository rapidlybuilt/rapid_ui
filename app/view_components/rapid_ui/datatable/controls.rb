module RapidUI
  module Datatable
    class Controls < ApplicationComponent
      attr_accessor :table

      renders_many_polymorphic(:items,
        filters: ->(**kwargs) { build(Filters, table:, **kwargs) },
        bulk_actions: ->(**kwargs) { build(BulkActions, table:, **kwargs) },
        per_page: ->(table:, **kwargs) { build(PerPage, table:, **kwargs) },
        pagination: ->(table:, **kwargs) { build(Pagination, table:, **kwargs) },
        exports: ->(table:, **kwargs) { build(Exports, table:, **kwargs) }
      )

      def initialize(table:, **kwargs)
        super(
          tag_name: :div,
          **kwargs,
        )

        @table = table
      end

      def call
        component_tag { safe_join(items) } unless items.empty?
      end
    end
  end
end
