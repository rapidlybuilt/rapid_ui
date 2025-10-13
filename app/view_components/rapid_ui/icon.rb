module RapidUI
  class Icon < ApplicationComponent
    attr_accessor :id
    attr_accessor :size
    attr_accessor :spin
    alias_method :spin?, :spin
    attr_accessor :css_class

    def initialize(id, size: 16, spin: false, **kwargs)
      @id = id
      @size = size
      @spin = spin
      @css_class = combine_classes(kwargs[:additional_class], kwargs[:class])
    end

    def call
      return unless id

      if id == "logo"
        image_tag("rapid_ui/favicon-96x96.png", width: size, height: size, class: css_class)
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
      svg_content = svg_content.sub(/ width="[^"]*"/, " width=\"#{size}\"")
      svg_content = svg_content.sub(/ height="[^"]*"/, " height=\"#{size}\"")

      css = css_class
      css = (css ? "#{css} spin" : "spin") if spin

      svg_content = svg_content.sub(/<svg/, "<svg class=\"#{css}\"") if css.present?

      raw svg_content
    end
  end
end
