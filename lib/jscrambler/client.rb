module JScrambler
  class Client

    attr_reader :config

    def initialize(json_config=nil)
      setup(json_config)
    end

    def setup(json_config=nil)
      @config = JScrambler::Config.new(json_config).to_hash
    end

    def zip_files
      @zipfile = JScrambler::Archiver.new(config['fileSrc'].to_a)
    end

    def upload_to_jscrambler

    end

    private

    def api
      @api ||= Faraday.new(:url => 'https://sushi.com') do |builder|
        builder.use       JScrambler::Middleware::HmacSignature
        builder.request   :multipart
        builder.request   :url_encoded
        builder.response  :logger
        builder.adapter   Faraday.default_adapter
      end
    end
  end
end
