module RapidUI
  module Controls
    module ButtonsHelper
      def new_button(*args, **kwargs, &block)
        ui.build Button, *args, **kwargs, &block
      end

      def button(*content, **kwargs, &block)
        render new_button(*content, **kwargs), &block
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
