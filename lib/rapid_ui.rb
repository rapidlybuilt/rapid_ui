require "rapid_ui/version"
require "rapid_ui/railtie"

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
  end
end
