require 'json'
require 'zip'
require 'openssl'
require 'base64'
require 'faraday'
require 'faraday_middleware'
require 'time'
require 'jscrambler/config'
require 'jscrambler/client'
require 'jscrambler/errors'
require 'jscrambler/archiver'
require 'jscrambler/middleware/default_params'
require 'jscrambler/middleware/authentication'

module JScrambler

  class << self
    def upload_code(json_config=nil)
      JScrambler::Client.new(json_config).upload_to_jscrambler
    end

    def poll_project

    end

    def download_code

    end

    def get_info

    end
  end
end
