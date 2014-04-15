require 'rake'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = %w[-w]
  t.rspec_opts = %w[-c]
end

task default: :spec
