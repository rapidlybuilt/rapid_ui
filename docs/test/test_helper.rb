# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# FIXME: coverage is not working. everything is 0.0%
unless RUBY_ENGINE == "truffleruby"
  require "simplecov"
  SimpleCov.start 'rails' do
    add_filter "/test/"
  end
end

require_relative "../config/environment"
require "rails/test_help"

require "minitest/mock"

require_relative "../../test/support/capybara_support"
