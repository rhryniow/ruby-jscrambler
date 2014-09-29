module JScrambler
  class Project

    attr_reader :id, :client, :received_at, :finished_at, :js_files, :html_files

    def initialize(options={}, client)
      raise ArgumentError, 'Cannot create project without ID' unless options['id']

      @client = client

      @id = options['id']
      @sources = options['sources']
      @received_at = options['received_at']
      @finished_at = options['finished_at']
      @js_files = options['js_files']
      @html_files = options['html_files']
    end

    def files
      @files ||= @sources.to_a.map { |file_hash| JScrambler::Project::File.new(file_hash, client) }
    end

    def status
      client.handle_response(client.api.get("code/#{id}.json")) do |json_response|
        json_response['finished_at'] ? :finished : :processing
      end
    end
  end
end
