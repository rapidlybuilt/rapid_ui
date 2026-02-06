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

      renders_one :footer, ->(**kwargs) { build(Footer, table: self, **kwargs) }

      def initialize(*args, factory:, **kwargs, &block)
        raise "factory is required" unless factory
        self.factory = factory

        super(*args, **kwargs, &block)
        self.stimulus_controller = "datatable"
      end

      def before_render
        super

        build_footer unless only_ever_one_page? && skip_export?
      end
    end
  end
end
