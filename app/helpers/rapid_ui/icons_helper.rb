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
    def icon_tag(name, size: 16, **options)
      # Read the SVG file from the gem's assets
      full_path = RapidUI.root.join("vendor/lucide_icons/#{name}.svg")
      return content_tag(:span, "?", **options) unless File.exist?(full_path)

      svg_content = File.read(full_path)

      # Set size and class
      svg_content = svg_content.gsub(/ width="[^"]*"/, " width=\"#{size}\"")
      svg_content = svg_content.gsub(/ height="[^"]*"/, " height=\"#{size}\"")
      svg_content = svg_content.gsub(/<svg/, "<svg class=\"#{options[:class]}\"") if options[:class]

      raw svg_content
    end
  end
end
