require_relative "lib/rapid_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "rapid_ui"
  spec.version     = RapidUI::VERSION
  spec.authors     = [ "Dan Cunning" ]
  spec.email       = [ "dan@rapidlybuilt.com" ]
  spec.homepage    = "https://rapidlybuilt.com/tools/rapid-ui"
  spec.summary     = "RapidUI - A Rails UI component library."
  spec.description = "RapidUI is a comprehensive Rails UI component library built with ViewComponent and Tailwind CSS."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dcunning/rapid_ui"
  # spec.metadata["changelog_uri"] = "https://github.com/dcunning/rapid_ui/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,vendor/lucide_icons}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.3"
  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.add_dependency "importmap-rails", "~> 2.0"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "stimulus-rails", "~> 1.0"
  spec.add_dependency "view_component", "~> 4"

  spec.add_development_dependency "propshaft", "~> 1.0"
  spec.add_development_dependency "tailwindcss-ruby", "~> 4.0"
end
