module RapidUI
  module Feedback
    module AlertsHelper
      def new_alert(*body, **kwargs, &block)
        ui.build Alert, *body, **kwargs, &block
      end

      def alert(*body, **kwargs, &block)
        render new_alert(*body, **kwargs), &block
      end

      Alert.variants.each do |variant|
        method_variant = variant.underscore

        # Regular variants
        define_method(:"new_#{method_variant}_alert") do |*args, **kwargs, &block|
          new_alert(*args, **kwargs, variant:, &block)
        end

        define_method(:"#{method_variant}_alert") do |*args, **kwargs, &block|
          alert(*args, **kwargs, variant:, &block)
        end
      end
    end
  end
end
