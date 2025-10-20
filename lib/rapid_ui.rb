require "rapid_ui/version"
require "rapid_ui/engine"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("rapid_ui" => "RapidUI")
loader.setup

module RapidUI
  mattr_accessor :importmap, default: Importmap::Map.new

  class << self
    def root
      Pathname.new(File.expand_path("..", __dir__))
    end

    def merge_classes(css_class, *more_classes)
      return css_class if more_classes.empty? # optimize for common scenerio

      result = [ css_class, *more_classes ].compact.join(" ")
      result if result.present?
    end
  end
end

require "view_component"
require "rapid_ui/view_component_ext"
