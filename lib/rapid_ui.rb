require "rapid_ui/version"
require "rapid_ui/railtie"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("rapid_ui" => "RapidUI")
loader.setup

module RapidUI
  # Your code goes here...
end
