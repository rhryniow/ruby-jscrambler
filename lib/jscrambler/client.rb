module JScrambler
  class Client

    attr_reader :config

    def initialize(json_config=nil)
      setup(json_config)
    end

    def setup(json_config=nil)
      @config = JScrambler::Config.new(json_config).to_hash
    end

    def upload_to_jscrambler
      zipfile = archiver.zip
      payload = {
          files: [Faraday::UploadIO.new(zipfile.path, 'application/octet-stream')]
      }
      api.post('code.json', payload)
    end

    private

    def archiver
      @archiver = JScrambler::Archiver.new(config['filesSrc'].to_a)
    end

    def api
      @api ||= Faraday.new(:url => url) do |builder|
        builder.use       JScrambler::Middleware::DefaultParams
        builder.use       JScrambler::Middleware::Authentication
        builder.request   :multipart
        builder.request   :url_encoded
        builder.response  :logger
        builder.response  :json
        builder.adapter   Faraday.default_adapter
      end
    end

    def url
      protocol = config['port'] == 443 ? 'https' : 'http'
      "#{protocol}://#{config['host']}/v#{config['apiVersion']}"
    end
  end
end
