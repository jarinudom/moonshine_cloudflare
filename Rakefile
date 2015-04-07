require "rake"
require "rake/testtask"

desc "Default: specs"
task default: :spec

require "rspec/core/rake_task"
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = ["--backtrace"]
end

