module RapidUI
  module Controls
    module ButtonsHelper
      include SharedHelper

      def new_button(*body, **kwargs, &block)
        ui.build Button, **kwargs do |button|
          new_component_content(button, body, &block)
        end
      end

      def button(*body, **kwargs, &block)
        render new_button(**kwargs) do
          component_content(body, &block)
        end
      end

      Button.variants.each do |variant|
        method_variant = variant.underscore

        define_method(:"new_#{method_variant}_button") do |*args, **kwargs, &block|
          new_button(*args, **kwargs, variant:, &block)
        end

        define_method(:"#{method_variant}_button") do |*args, **kwargs, &block|
          button(*args, **kwargs, variant:, &block)
        end
      end
    end
  end
end
