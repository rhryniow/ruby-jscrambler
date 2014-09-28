module JScrambler
  class Config

    DEFAULT_CONFIG_FILE = 'config/jscrambler_config.json'

    def initialize(json_config=nil)
      begin
        @config = JSON.parse(json_config || File.open(DEFAULT_CONFIG_FILE, 'rb').read)
        if @config['keys']['accessKey'].empty? || @config['keys']['secretKey'].empty?
          raise JScrambler::MissingKeys, 'Missing Access Key or Secret Key'
        end
      rescue JSON::ParserError
        @config = JSON.parse(File.open(DEFAULT_CONFIG_FILE, 'rb').read)
      end
    end

    def to_hash
      @config
    end
  end
end
