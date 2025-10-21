module RapidUI
  class Badge < ApplicationComponent
    attr_accessor :variant

    attr_accessor :pill
    alias_method :pill?, :pill

    def initialize(*children, variant: "dark-primary", pill: false, **kwargs)
      super(tag_name: :span, **kwargs)

      with_content(safe_components(*children)) if children.any?

      @variant = variant
      @pill = pill

      yield self if block_given?
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
