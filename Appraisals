# frozen_string_literal: true

# Default: no optional pagination gem (adapter tests that need Kaminari are skipped).
# No block = inherit base Gemfile.
appraise "default" do
end

# Kaminari 1.2: run full test suite including Adapters::Kaminari tests.
appraise "kaminari-1.2" do
  gem "kaminari", "~> 1.2"
end

# Rails 8.1 (ActiveRecord 8.1): run full test suite including Adapters::ActiveRecord behavior.
appraise "activerecord-8.1" do
  gem "rails", "~> 8.1"
  gem "sqlite3", "~> 2"
end
