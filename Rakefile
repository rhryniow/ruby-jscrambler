require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

namespace :jscrambler do
  desc 'Send files to JScrambler and save obfuscated version'
  task :process, [:config_file_path] do |t, args|
    require 'jscrambler'

    JScrambler.process(args[:config_file_path])
  end
end

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec
