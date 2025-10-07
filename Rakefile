require "bundler/setup"

require "bundler/gem_tasks"

require "rubocop/rake_task"

RuboCop::RakeTask.new

# Define test task to run tests in the dummy Rails app
task :test do
  system("bin/test")
end

task default: %i[rubocop test]
