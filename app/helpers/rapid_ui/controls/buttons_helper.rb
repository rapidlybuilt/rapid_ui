module RapidUI
  module Controls
    module ButtonsHelper
      include SharedHelper

      def new_button(*args, **kwargs, &block)
        Button.new(*args, **kwargs, &block)
      end

      def button(children = nil, **kwargs, &block)
        children = components(children, &block)
        render new_button(children, **kwargs)
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
