module RapidUI
  module Content
    module BadgesHelper
      def new_badge(*args, **kwargs, &block)
        Badge.new(*args, **kwargs, &block)
      end

      def badge(*args, **kwargs)
        render new_badge(*args, **kwargs)
      end

      Badge.variants.each do |variant|
        method_variant = variant.underscore

        # Regular variants
        define_method(:"new_#{method_variant}_badge") do |text, **kwargs|
          new_badge(text, **kwargs, variant:)
        end

        define_method(:"#{method_variant}_badge") do |text, **kwargs|
          badge(text, **kwargs, variant:)
        end

        # Pill variants
        define_method(:"new_#{method_variant}_pill_badge") do |text, **kwargs|
          new_badge(text, **kwargs, variant:, pill: true)
        end

        define_method(:"#{method_variant}_pill_badge") do |text, **kwargs|
          badge(text, **kwargs, variant:, pill: true)
        end
      end
    end
  end
end
