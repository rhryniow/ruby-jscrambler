module JScrambler
  class Client

    attr_reader :config

    def initialize(json_config=nil)
      setup(json_config)
    end

    def setup(json_config=nil)
      begin
        @config = JSON.parse(json_config || File.open(CONFIG_FILE, 'rb').read)
        if config['keys']['accessKey'].empty? || config['keys']['secretKey'].empty?
          raise JScrambler::MissingKeys, 'Missing Access Key or Secret Key'
        end
      rescue JSON::ParserError
        @config = JSON.parse(File.open(CONFIG_FILE, 'rb').read)
      end
    end

    def zip_files
      @zipfile = JScrambler::Archiver.new(config['fileSrc'].to_a)
    end

    def upload_to_jscrambler

    end
  end
end
