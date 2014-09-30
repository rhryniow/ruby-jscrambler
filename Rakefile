require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

namespace :jscrambler do
  desc 'Send files to JScrambler and save obfuscated version'
  task :process do
    require 'jscrambler'

    JScrambler.process
  end
end

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec
