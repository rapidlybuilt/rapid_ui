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
      # Read the SVG file from configured icon paths
      full_path = find_icon_path(name)
      raise NotImplementedError.new("Icon #{name} not found") unless full_path

      svg_content = File.read(full_path)

      # Set size and class
      svg_content = svg_content.sub(/ width="[^"]*"/, " width=\"#{size}\"") if size
      svg_content = svg_content.sub(/ height="[^"]*"/, " height=\"#{size}\"") if size

      css = dynamic_css_class
      svg_content = svg_content.sub(/<svg/, "<svg class=\"#{css}\"") if css.present?

      raw svg_content
    end

    private

    def find_icon_path(icon_name)
      self.class.svg_icon_paths_by_name[icon_name]
    end

    class << self
      def image_icons
        IMAGE_ICONS.keys
      end

      def svg_icon_paths_by_name
        @svg_icon_paths_by_name ||= build_svg_icon_paths_by_name
      end

      def svg_icons
        svg_icon_paths_by_name.keys.sort
      end

      # Alias for backwards compatibility
      alias_method :lucide_icons, :svg_icons

      private

      def build_svg_icon_paths_by_name
        paths_by_name = {}
        RapidUI.config.icon_paths.each do |icon_path|
          Dir.glob(File.join(icon_path, "*.svg")).each do |full_path|
            name = File.basename(full_path, ".svg")
            # First path wins (don't overwrite if already found)
            paths_by_name[name] ||= full_path
          end
        end
        paths_by_name
      end
    end
  end
end
