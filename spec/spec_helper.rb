require 'bundler/setup'
require 'rspec'
Bundler.setup

require 'jscrambler'

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.color_enabled = true
  config.formatter     = 'documentation'

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:each) do
    stub_const('JScrambler::CONFIG_FILE', 'spec/fixtures/config.json')
  end
end
