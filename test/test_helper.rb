# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

unless RUBY_ENGINE == "truffleruby"
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/docs/"
  end
end

require_relative "../test/dummy/config/environment"
require_relative "../lib/rapid_ui"
require "rails/test_help"

require "minitest/mock"

require_relative "support/capybara_support"
