module JScrambler
  class Client

    attr_reader :config

    def initialize(json_config=nil)
      setup(json_config)
    end

    def setup(json_config=nil)
      begin
        @config = JSON.parse(json_config || File.open(CONFIG_FILE, 'rb').read)
      rescue JSON::ParserError
        @config = JSON.parse(File.open(CONFIG_FILE, 'rb').read)
      end
    end
  end
end
