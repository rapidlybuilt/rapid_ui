# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

unless RUBY_ENGINE == "truffleruby"
  require "simplecov"

  # Per-appraisal coverage dir so multiple runs don't overwrite; merge with rake coverage:report
  appraisal_name = if (gemfile = ENV["BUNDLE_GEMFILE"]) && gemfile.include?("gemfiles/")
    File.basename(gemfile, ".gemfile")
  else
    "default"
  end
  SimpleCov.coverage_dir("coverage/#{appraisal_name}")
  SimpleCov.command_name(appraisal_name)

  SimpleCov.start do
    add_group "Controllers", "app/controllers"
    add_group "Helpers", "app/helpers"
    add_group "Library", "lib/rapid_ui"
    add_group "View Components", "app/view_components"

    # rather large subset of view components
    add_group "Datatable", "app/view_components/rapid_ui/datatable"

    add_filter "/test/"
    add_filter "/docs/"
  end
end

require_relative "../test/dummy/config/environment"
require_relative "../lib/rapid_ui"
require_relative "view_components/rapid_ui/view_component_test_case"

RapidUI.loader.eager_load
Rails.application.eager_load!

require "rails/test_help"

require "minitest/mock"
Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }
