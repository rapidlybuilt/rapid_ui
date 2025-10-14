module RapidUI
  class Badge < ApplicationComponent
    attr_accessor :text
    attr_accessor :variant

    attr_accessor :pill
    alias_method :pill?, :pill

    def initialize(text, variant: "dark-primary", pill: false, **kwargs)
      super(**kwargs)

      @text = text
      @variant = variant
      @pill = pill
    end

    def dynamic_css_class
      combine_classes(
        ("badge badge-#{variant}" if variant),
        ("badge-pill" if pill?),
        super,
      )
    end

    def call
      component_tag(:span, text)
    end

    class << self
      def variants
        [ "light-primary", "light-secondary", "dark-primary", "dark-secondary", "success", "danger", "warning", "info" ]
      end
    end
  end
end
