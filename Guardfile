guard :minitest do
  # Watch all test files
  watch(%r{^test/(.*)_test\.rb$})

  # Watch app files and run corresponding tests
  watch(%r{^app/view_components/(.*)\.rb$}) { |m| "test/view_components/#{m[1]}_test.rb" }
  watch(%r{^app/helpers/(.*)\.rb$}) { |m| "test/helpers/#{m[1]}_test.rb" }
  watch(%r{^lib/(.*)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
end
