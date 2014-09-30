module JScrambler
  class Client

    attr_reader :config

    def initialize(json_config=nil)
      setup(json_config)
    end

    def setup(json_config=nil)
      @config = JScrambler::Config.new(json_config).to_hash
    end

    def new_project
      zipfile = archiver.zip(config['filesSrc'].to_a)
      payload = {
          files: [Faraday::UploadIO.new(zipfile.path, 'application/octet-stream')]
      }

      LOGGER.info "Uploading #{payload[:files].count} file(s) to JScrambler"
      handle_response(api.post('code.json', payload)) do |json_response|
        JScrambler::Project.new(json_response, self)
      end
    end

    def projects(options={})
      handle_response(api.get('code.json', options)) do |response|
        response.map { |project_hash| JScrambler::Project.new(project_hash, self) }
      end
    end

    def handle_response(response)
      begin
        body_hash = JSON.parse(response.body)
      rescue JSON::ParserError
        body_hash = response.body
      end

      LOGGER.debug response.body

      if response.status == 200
        yield(body_hash) if block_given?
      else
        raise JScrambler::ApiError, "Error: #{body_hash['message']}"
      end
    end

    def api
      @api ||= Faraday.new(:url => url) do |builder|
        builder.use       JScrambler::Middleware::DefaultParams
        builder.use       JScrambler::Middleware::Authentication
        builder.request   :multipart
        builder.request   :url_encoded
        # builder.response  :logger
        builder.adapter   Faraday.default_adapter
      end
    end

    private

    def archiver
      @archiver = JScrambler::Archiver.new
    end

    def url
      protocol = config['port'] == 443 ? 'https' : 'http'
      "#{protocol}://#{config['host']}/v#{config['apiVersion']}"
    end
  end
end
