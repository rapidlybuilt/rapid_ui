module RapidUI
  module Content
    module BadgesHelper
      def new_badge(*body, **kwargs, &block)
        ui.build Badge, *body, **kwargs, &block
      end

      def badge(*body, **kwargs, &block)
        render new_badge(*body, **kwargs), &block
      end

      Badge.variants.each do |variant|
        method_variant = variant.underscore

        # Regular variants
        define_method(:"new_#{method_variant}_badge") do |*args, **kwargs, &block|
          new_badge(*args, **kwargs, variant:, &block)
        end

        define_method(:"#{method_variant}_badge") do |*args, **kwargs, &block|
          badge(*args, **kwargs, variant:, &block)
        end

        # Pill variants
        define_method(:"new_#{method_variant}_pill_badge") do |*args, **kwargs, &block|
          new_badge(*args, **kwargs, variant:, pill: true, &block)
        end

        define_method(:"#{method_variant}_pill_badge") do |*args, **kwargs, &block|
          badge(*args, **kwargs, variant:, pill: true, &block)
        end
      end
    end
  end
end
