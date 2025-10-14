module RapidUI
  class Button < ApplicationComponent
    attr_accessor :children
    attr_accessor :path
    attr_accessor :title
    attr_accessor :variant
    attr_accessor :size

    attr_accessor :disabled
    alias_method :disabled?, :disabled

    def initialize(children: Components.new, path: nil, title: nil, variant: nil, size: nil, disabled: false, **kwargs)
      super(**kwargs)

      @children = children
      @path = path
      @title = title
      @variant = variant
      @size = size
      @disabled = disabled
    end

    def dynamic_css_class
      combine_classes(
        ("btn btn-#{variant}" if variant),
        ("btn-#{size}" if size),
        super,
      )
    end

    def call
      body = render(children)
      tag_name = path ? :a : :button
      component_tag(tag_name, body, href: path, title:, disabled:)
    end

    class << self
      def variants
        [ "primary", "secondary", "outline-primary", "naked" ]
      end
    end
  end
end
