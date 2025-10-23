module RapidUI
  class Button < ApplicationComponent
    include HasBodyContent

    attr_accessor :path
    attr_accessor :title
    attr_accessor :variant
    attr_accessor :size

    attr_accessor :disabled
    alias_method :disabled?, :disabled

    def initialize(*body, path: nil, title: nil, variant: nil, size: nil, disabled: false, **kwargs)
      super(tag_name: nil, **kwargs)

      self.body = body

      @path = path
      @title = title
      @variant = variant
      @size = size
      @disabled = disabled

      yield self if block_given?
    end

    def dynamic_css_class
      merge_classes(
        ("btn btn-#{variant}" if variant),
        ("btn-#{size}" if size),
        super,
      )
    end

    def dynamic_tag_name
      @tag_name || (path ? :a : :button)
    end

    def call
      component_tag(content, href: path, title:, disabled:)
    end

    class << self
      def variants
        [
          "primary", "secondary", "outline-primary", "naked", "success", "warning", "danger",
          "outline-success", "outline-warning", "outline-danger",
        ]
      end
    end
  end
end
