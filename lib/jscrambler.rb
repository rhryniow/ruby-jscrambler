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
require 'jscrambler/project'
require 'jscrambler/project/file'
require 'jscrambler/middleware/default_params'
require 'jscrambler/middleware/authentication'

module JScrambler

  class << self
    def upload_code(json_config=nil)
      JScrambler::Client.new(json_config).new_project
    end

    def poll_project(json_config=nil)

    end

    def download_code(json_config=nil)

    end

    def get_info(json_config=nil)

    end

    def projects(json_config=nil)
      JScrambler::Client.new(json_config).projects
    end
  end
end
