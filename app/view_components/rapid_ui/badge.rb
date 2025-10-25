module RapidUI
  class Badge < ApplicationComponent
    include HasBodyContent

    attr_accessor :variant

    attr_accessor :pill
    alias_method :pill?, :pill

    def initialize(*body, variant: "dark-primary", pill: false, **kwargs)
      super(tag_name: :span, **kwargs)

      self.body = body
      @variant = variant
      @pill = pill
    end

    def dynamic_css_class
      merge_classes(
        ("badge badge-#{variant}" if variant),
        ("badge-pill" if pill?),
        super,
      )
    end

    def call
      component_tag(content)
    end

    class << self
      def variants
        [ "light-primary", "light-secondary", "dark-primary", "dark-secondary", "success", "danger", "warning", "info" ]
      end
    end
  end
end
