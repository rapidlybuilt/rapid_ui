module RapidUI
  module Content
    module BadgesHelper
      def new_badge(*args, **kwargs, &block)
        rapid_ui.build Badge, *args, **kwargs, &block
      end

      def badge(*args, **kwargs, &block)
        render new_badge(*args, **kwargs), &block
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
