require "bundler/setup"

require "bundler/gem_tasks"

require "rubocop/rake_task"

RuboCop::RakeTask.new

# Define test task to run tests in the dummy Rails app
task :test do
  system("bin/test") || exit($?.exitstatus || 1)
end

namespace :appraisal do
  task :test do
    system("bundle exec appraisal bin/test") || exit($?.exitstatus || 1)
  end
end

namespace :docs do
  task :test do
    system("bin/docs bin/test") || exit($?.exitstatus || 1)
  end
end

namespace :coverage do
  desc "Merge coverage from all appraisal runs (run after appraisal rake test)"
  task :report do
    require "simplecov"
    result_files = Dir["coverage/*/.resultset.json"]
    result_files << "coverage/.resultset.json" if File.file?("coverage/.resultset.json")
    result_files.uniq!
    if result_files.empty?
      warn "No coverage .resultset.json found. Run tests first, e.g. bundle exec appraisal rake test"
      next
    end
    SimpleCov.collate result_files
  end

  desc "Clean coverage directory"
  task :clean do
    system("rm -rf coverage")
  end
end

task default: %i[rubocop coverage:clean appraisal:test coverage:report docs:test]
