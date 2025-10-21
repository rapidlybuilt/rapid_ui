module RapidUI
  module Content
    module AlertsHelper
      def new_alert(*args, **kwargs, &block)
        ui.build Alert, *args, **kwargs, &block
      end

      def alert(*args, **kwargs, &block)
        render new_alert(*args, **kwargs), &block
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
