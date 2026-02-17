source "https://rubygems.org"

# Specify your gem's dependencies in rapid_ui.gemspec.
gemspec

gem "puma"

# Markdown (docs app: .md templates with GFM + syntax highlighting)
gem "kramdown"
gem "kramdown-parser-gfm"
gem "rouge", "~> 4.0"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development do
  gem "guard", "~> 2"
  gem "guard-minitest", "~> 3"
  gem "web-console"
end

# Testing gems
group :test do
  gem "minitest-mock"
  gem "capybara", "~> 3.39"
  gem "cuprite", "~> 0.15"
  gem "simplecov", "~> 0.22"
  gem "spy", "~> 1.0"
end

group :development do
  gem "appraisal", "~> 2.4"
end
