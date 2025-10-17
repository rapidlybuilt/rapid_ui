module RapidUI
  class Button < ApplicationComponent
    attr_accessor :path
    attr_accessor :title
    attr_accessor :variant
    attr_accessor :size

    attr_accessor :disabled
    alias_method :disabled?, :disabled

    def initialize(*children, path: nil, title: nil, variant: nil, size: nil, disabled: false, **kwargs, &block)
      with_content(safe_components(*children)) if children.any?
      @path = path
      @title = title
      @variant = variant
      @size = size
      @disabled = disabled

      super(tag_name: nil, **kwargs, &block)
    end

    def dynamic_css_class
      combine_classes(
        ("btn btn-#{variant}" if variant),
        ("btn-#{size}" if size),
        super,
      )
    end

    def dynamic_tag_name
      @tag_name || (path ? :a : :button)
    end

    def call
      body = render(content)
      component_tag(body, href: path, title:, disabled:)
    end

    class << self
      def variants
        [ "primary", "secondary", "outline-primary", "naked", "success", "warning", "danger", "outline-success", "outline-warning", "outline-danger" ]
      end
    end
  end
end
