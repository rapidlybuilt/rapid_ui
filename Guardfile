# Guard configuration for rapid_ui (automated test runner)
# Run with: bundle exec guard
#
# From the rapid_ui directory, Guard watches app/, lib/, and test/ and runs
# the corresponding Minitest tests when files change.

guard :minitest, all_on_start: true, test_folders: %w[test] do
  # Watch test files directly — run the changed test
  watch(%r{^test/(.*)_test\.rb$})

  # View components: app/view_components/rapid_ui/... -> test/view_components/rapid_ui/...
  watch(%r{^app/view_components/(.*)\.rb$}) { |m| "test/view_components/#{m[1]}_test.rb" }
  watch(%r{^app/view_components/(.*?)\.(html\.)?erb$}) { |m| "test/view_components/#{m[1]}_test.rb" }

  # When a concern changes, run all view component tests (concerns are shared)
  watch(%r{^app/view_components/concerns/}) do
    Dir["test/view_components/**/*_test.rb"]
  end

  # Helpers: app/helpers/rapid_ui/... -> test/helpers/rapid_ui/...
  watch(%r{^app/helpers/(.*)\.rb$}) { |m| "test/helpers/#{m[1]}_test.rb" }

  # Library: no 1:1 test mapping (e.g. test/rapid_ui_test.rb); run full suite when lib changes
  watch(%r{^lib/(.*)\.rb$}) { Dir["test/**/*_test.rb"] }

  # Test infrastructure changes — run full suite
  watch(%r{^test/test_helper\.rb$}) { Dir["test/**/*_test.rb"] }
  watch(%r{^test/support/}) { Dir["test/**/*_test.rb"] }
end
