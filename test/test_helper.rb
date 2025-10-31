# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

unless RUBY_ENGINE == "truffleruby"
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/docs/"
  end
end

require_relative "../docs/config/environment"
require "rails/test_help"

require "minitest/mock"

require "capybara/rails"
require "capybara/minitest"
