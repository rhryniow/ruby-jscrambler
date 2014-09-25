require 'byebug'
require 'json'
require 'jscrambler/client'

module JScrambler

  CONFIG_FILE = 'config/config.json'

  class << self
    def upload_code(json_config=nil)
      JScrambler::Client.new(json_config)
    end
  end
end
