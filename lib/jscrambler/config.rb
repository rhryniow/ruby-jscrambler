module JScrambler
  class Config

    DEFAULT_CONFIG_FILE = 'config/jscrambler_config.json'

    def initialize(config_file_path=nil)
      begin
        config_file_path ||= DEFAULT_CONFIG_FILE
        @config = JSON.parse(File.open(config_file_path, 'rb').read)
        if @config['keys']['accessKey'].empty? || @config['keys']['secretKey'].empty?
          raise JScrambler::MissingKeys, 'Missing Access Key or Secret Key'
        end
      rescue JSON::ParserError
        raise JScrambler::ConfigError, "Could not process config file #{config_file_path}"
      rescue Errno::ENOENT, Errno::EISDIR
        raise JScrambler::ConfigError, "Could not find config file #{config_file_path}"
      end
    end

    def to_hash
      @config
    end
  end
end
