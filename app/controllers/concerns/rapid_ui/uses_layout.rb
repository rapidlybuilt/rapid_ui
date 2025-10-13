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

          attr_writer :layout
        end
      end

      def layout
        @layout ||= layout_component_class.new
      end
    end
  end
end
