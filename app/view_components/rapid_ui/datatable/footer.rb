module RapidUI
  module Datatable
    class Footer < ApplicationComponent
      renders_many_polymorphic(:items,
        per_page: ->(table:) { build(FooterPerPage, table:) },
        pagination: ->(table:) { build(FooterPagination, table:) },
        exports: ->(table:) { build(FooterExports, table:) },
        spacer: ->(table:) { build(FooterSpacer, table:) }
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

        build_spacer(table: @table) if @table.only_ever_one_page?
        build_per_page(table: @table) unless @table.only_ever_one_page?
        build_pagination(table: @table) unless @table.only_ever_one_page?
        build_exports(table: @table) unless @table.skip_export?
      end
    end
  end
end
