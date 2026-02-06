module RapidUI
  module Datatable
    class Footer < ApplicationComponent
      renders_many_polymorphic(:items,
        per_page: ->(table:, **kwargs) { build(FooterPerPage, table:, **kwargs) },
        pagination: ->(table:, **kwargs) { build(FooterPagination, table:, **kwargs) },
        exports: ->(table:, **kwargs) { build(FooterExports, table:, **kwargs) }
      )

      def initialize(table:, **kwargs)
        super(
          tag_name: :div,
          **kwargs,
          class: merge_classes("datatable-footer", kwargs[:class])
        )

        @table = table
      end

      def call
        component_tag { safe_join(items) } unless items.empty?
      end

      def before_render
        super

        # TODO: pull out of component classes completely into UsesRapidTable

        unless @table.skip_pagination? || @table.only_ever_one_page?
          build_per_page(table: @table)
          build_pagination(table: @table)
        end

        unless @table.skip_export?
          build_exports(table: @table)
        end
      end
    end
  end
end
