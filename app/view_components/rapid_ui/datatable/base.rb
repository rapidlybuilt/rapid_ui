# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < RapidTable::Base # TODO: ApplicationComponent?!
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

      def initialize(*args, factory:, **kwargs, &block)
        raise "factory is required" unless factory
        self.factory = factory

        super(*args, **kwargs, &block)
        self.stimulus_controller = "datatable"
      end
    end
  end
end
