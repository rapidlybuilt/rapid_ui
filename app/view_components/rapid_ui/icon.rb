module RapidUI
  class Icon < ApplicationComponent
    IMAGE_ICONS = {
      "logo" => "rapid_ui/favicon-96x96.png",
    }

    attr_accessor :name
    attr_accessor :size
    attr_accessor :spin
    alias_method :spin?, :spin

    def initialize(name, size: nil, spin: false, factory: nil, **kwargs)
      assert_only_class_kwarg(kwargs)

      @name = name
      @size = size || 16
      @spin = spin
      @css_class = kwargs[:class]
      @factory = factory

      yield self if block_given?
    end

    def dynamic_css_class
      merge_classes(
        ("spin" if spin?),
        super,
      )
    end

    def call
      return unless name

      image_path = IMAGE_ICONS[name]
      if image_path
        image_tag(image_path, width: size, height: size, class: dynamic_css_class)
      else
        svg_content
      end
    end

    def svg_content
      # Read the SVG file from the gem's assets
      full_path = RapidUI.root.join("vendor/lucide_icons/#{name}.svg")
      raise NotImplementedError.new("Icon #{name} not found") unless File.exist?(full_path)

      svg_content = File.read(full_path)

      # Set size and class
      svg_content = svg_content.sub(/ width="[^"]*"/, " width=\"#{size}\"") if size
      svg_content = svg_content.sub(/ height="[^"]*"/, " height=\"#{size}\"") if size

      css = dynamic_css_class
      svg_content = svg_content.sub(/<svg/, "<svg class=\"#{css}\"") if css.present?

      raw svg_content
    end

    class << self
      def image_icons
        IMAGE_ICONS.keys
      end

      def lucide_icons
        Dir.glob(File.join(RapidUI.root, "vendor/lucide_icons", "*.svg")).map do |path|
          File.basename(path, ".svg")
        end.sort
      end
    end
  end
end
