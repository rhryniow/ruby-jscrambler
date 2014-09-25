require 'json'
require 'zip'
require 'jscrambler/client'
require 'jscrambler/errors'
require 'jscrambler/archiver'

module JScrambler

  CONFIG_FILE = 'config/config.json'

  class << self
    def upload_code(json_config=nil)
      JScrambler::Client.new(json_config)
    end
  end
end
