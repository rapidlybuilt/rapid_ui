module RapidUI
  module Datatable
    class Controls < ApplicationComponent
      attr_accessor :table

      # TODO: dynamically add polymorphic items from the specific module (bulk_actions, pagination, etc)
      renders_many_polymorphic(:items,
        filters: ->(**kwargs) { build(Filters, table:, **kwargs) },
        bulk_actions: ->(**kwargs) { build(BulkActions::Container, table:, **kwargs) },
        per_page: ->(table:, **kwargs) { build(Pagination::PerPage, table:, **kwargs) },
        pagination: ->(table:, **kwargs) { build(Pagination::Links, **kwargs) },
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
