# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < RapidTable::Base # TODO: ApplicationComponent?!
      include HasComponentTag
      extend RendersPolymorphic
      extend RapidTable::DSL

      include RendersWithFactory
      include SelectFilter::Container

      renders_one :header, ->(**kwargs) do
        build(Controls, table: self, **kwargs, class: RapidUI.merge_classes("datatable-header", kwargs[:class]))
      end

      renders_one :footer, ->(**kwargs) do
        build(Controls, table: self, **kwargs, class: RapidUI.merge_classes("datatable-footer", kwargs[:class]))
      end

      def initialize(*args, tag_name: :div, id:, data: {}, factory:, **kwargs, &block)
        raise "factory is required" unless factory
        self.factory = factory

        klass = kwargs[:class]
        super(*args, **kwargs.except(:class), &block)

        initialize_component_tag(tag_name:, id:, data:, class: klass)
        self.stimulus_controller = "datatable"
      end

      def dynamic_data
        merge_data(
          data,
          ({ controller: stimulus_controller } if stimulus_controller.present?),
        )
      end
    end
  end
end
