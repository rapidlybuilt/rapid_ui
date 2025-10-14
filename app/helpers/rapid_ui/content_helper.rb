module RapidUI
  module ContentHelper
    def badge(text, variant: "dark-primary", pill: false, **kwargs)
      render Badge.new(text, variant:, pill:, **kwargs)
    end

    Badge.variants.each do |variant|
      define_method(:"#{variant.underscore}_badge") do |text, **kwargs|
        badge(text, **kwargs, variant:)
      end

      define_method(:"#{variant.underscore}_pill_badge") do |text, **kwargs|
        badge(text, **kwargs, variant:, pill: true)
      end
    end
  end
end
