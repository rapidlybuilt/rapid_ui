# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

unless RUBY_ENGINE == "truffleruby"
  require "simplecov"
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

RapidUI.loader.eager_load
Rails.application.eager_load!

require "rails/test_help"

require "minitest/mock"

require_relative "support/capybara_support"
