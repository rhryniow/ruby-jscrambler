require 'bundler/setup'
require 'rspec'
Bundler.setup

require 'jscrambler'

RSpec.configure do |config|

  config.color      = true
  config.formatter  = 'documentation'
  config.order      = 'random'

  config.before(:each) do
    stub_const('JScrambler::Config::DEFAULT_CONFIG_FILE', 'spec/fixtures/config.json')
  end
end
