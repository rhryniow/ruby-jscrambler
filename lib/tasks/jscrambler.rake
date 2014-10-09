namespace :jscrambler do
  desc 'Send files to JScrambler and save obfuscated version'
  task :process, [:config_file_path] do |t, args|
    require 'jscrambler'

    JScrambler.process(args[:config_file_path])
  end
end
