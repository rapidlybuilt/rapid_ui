module RapidUI
  module UsesLayout
    extend ActiveSupport::Concern

    def uses_application_layout(conditions = {})
      uses_layout(RapidUI::ApplicationLayout, conditions)
    end

    def uses_layout(layout_class, conditions = {})
      include InstanceMethods

      layout(layout_class.layout_template, conditions)
      self.layout_component_class = layout_class
    end

    module InstanceMethods
      def self.included(base)
        base.class_eval do
          class_attribute :layout_component_class

          helper_method :layout
          helper_method :ui

          attr_writer :layout

          with_options to: :ui do
            delegate :layout
          end
        end
      end

      def ui
        @ui ||= UI.new(RapidUI::Factory.new, layout_component_class)
      end
    end

    class UI
      attr_accessor :factory
      attr_accessor :layout_component_class

      with_options to: :factory do
        delegate :build
      end

      def initialize(factory, layout_component_class)
        @factory = factory
        @layout_component_class = layout_component_class
      end

      def layout
        @layout ||= @factory.build(@layout_component_class, factory: @factory)
      end
    end
  end
end
