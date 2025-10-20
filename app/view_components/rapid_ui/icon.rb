module RapidUI
  class Icon < ApplicationComponent
    attr_accessor :id
    attr_accessor :size
    attr_accessor :spin
    alias_method :spin?, :spin

    def initialize(id, size: nil, spin: false, factory: nil, **kwargs)
      assert_only_class_kwarg(kwargs)

      @id = id
      @size = size || 16
      @spin = spin
      @css_class = kwargs[:class]
      @factory = factory
    end

    def dynamic_css_class
      merge_classes(
        ("spin" if spin?),
        super,
      )
    end

    def call
      return unless id

      if id == "logo"
        image_tag("rapid_ui/favicon-96x96.png", width: size, height: size, class: dynamic_css_class)
      else
        svg_content
      end
    end

    def svg_content
      # Read the SVG file from the gem's assets
      full_path = RapidUI.root.join("vendor/lucide_icons/#{id}.svg")
      raise NotImplementedError.new("Icon #{id} not found") unless File.exist?(full_path)

      svg_content = File.read(full_path)

      # Set size and class
      svg_content = svg_content.sub(/ width="[^"]*"/, " width=\"#{size}\"") if size
      svg_content = svg_content.sub(/ height="[^"]*"/, " height=\"#{size}\"") if size

      css = dynamic_css_class
      svg_content = svg_content.sub(/<svg/, "<svg class=\"#{css}\"") if css.present?

      raw svg_content
    end
  end
end
