require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

Dir.glob('lib/tasks/*.rake').each { |r| load r }

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec
