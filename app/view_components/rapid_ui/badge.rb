module RapidUI
  class Badge < ApplicationComponent
    attr_accessor :variant

    attr_accessor :pill
    alias_method :pill?, :pill

    def initialize(*children, variant: "dark-primary", pill: false, **kwargs, &block)
      with_content(safe_components(*children)) if children.any?

      @variant = variant
      @pill = pill

      super(tag_name: :span, **kwargs, &block)
    end

    def dynamic_css_class
      merge_classes(
        ("badge badge-#{variant}" if variant),
        ("badge-pill" if pill?),
        super,
      )
    end

    def call
      component_tag(render(content))
    end

    class << self
      def variants
        [ "light-primary", "light-secondary", "dark-primary", "dark-secondary", "success", "danger", "warning", "info" ]
      end
    end
  end
end
