source "https://rubygems.org"

# Specify your gem's dependencies in rapid_ui.gemspec.
gemspec

gem "puma"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development do
  gem "web-console"
end

# Testing gems
group :test do
  gem "capybara", "~> 3.39"
  gem "cuprite", "~> 0.15"
  gem "simplecov", "~> 0.22"
end

group :development, :test do
  gem "rouge", "~> 4.0", require: false
end
