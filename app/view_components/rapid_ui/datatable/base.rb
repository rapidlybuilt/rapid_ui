# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < RapidTable::Base # TODO: ApplicationComponent?!
      extend RendersPolymorphic
      extend RapidTable::DSL

      include RendersWithFactory
      include SelectFilter::Container

      renders_many_polymorphic(:filters,
        select_filter: ->(filter_id, options:, filter:) {
          build(SelectFilter, filter_id:, options:, filter:, table: self)
        },
        search_field_form: ->(**kwargs) {
          build(SearchFieldForm, table: self, **kwargs)
        }
      )

      renders_many_polymorphic(:footer_items,
        per_page: ->(table:) { build(FooterPerPage, table:) },
        pagination: ->(table:) { build(FooterPagination, table:) },
        exports: ->(table:) { build(FooterExports, table:) },
        spacer: ->(table:) { build(FooterSpacer, table:) }
      )

      def initialize(*args, factory:, **kwargs, &block)
        raise "factory is required" unless factory
        self.factory = factory

        super(*args, **kwargs, &block)
        self.stimulus_controller = "datatable"
      end

      def before_render
        build_default_footer_items if footer_items.empty?
      end

      def build_default_footer_items
        return if only_ever_one_page? && skip_export?

        build_spacer(table: self) if only_ever_one_page?
        build_per_page(table: self) unless only_ever_one_page?
        build_pagination(table: self) unless only_ever_one_page?
        build_exports(table: self) unless skip_export?
      end
    end
  end
end
