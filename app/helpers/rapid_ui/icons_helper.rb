module RapidUI
  module IconsHelper
    # Renders a Lucide icon as inline SVG
    #
    # @param name [String] The icon name (without .svg extension)
    # @param size [String, Integer] The size of the icon (default: 16)
    # @param **options Additional HTML attributes (including class)
    # @return [String] HTML-safe SVG string
    #
    # Example:
    #   <%= icon "menu", size: 20, class: "text-gray-600" %>
    #   <%= icon "search", size: 24, class: "hover:text-blue-500" %>
    def icon_tag(name, size: 16, spin: false, **options)
      # Read the SVG file from the gem's assets
      full_path = RapidUI.root.join("vendor/lucide_icons/#{name}.svg")
      return content_tag(:span, "?", **options) unless File.exist?(full_path)

      svg_content = File.read(full_path)

      # Set size and class
      svg_content = svg_content.sub(/ width="[^"]*"/, " width=\"#{size}\"")
      svg_content = svg_content.sub(/ height="[^"]*"/, " height=\"#{size}\"")

      css = options[:class]
      css = (css ? "#{css} spin" : "spin") if spin

      svg_content = svg_content.sub(/<svg/, "<svg class=\"#{css}\"") if css.present?

      raw svg_content
    end
  end
end
