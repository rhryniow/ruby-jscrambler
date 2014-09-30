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
      @files ||= begin
        if @sources.nil?
          @sources = client.handle_response(client.api.get("code/#{id}.json")) do |json_response|
            json_response['sources']
          end
        end
        @sources.to_a.map { |file_hash| JScrambler::Project::File.new(file_hash.merge('project_id' => id), client) }
      end
    end

    def status
      client.handle_response(client.api.get("code/#{id}.json")) do |json_response|
        status = json_response['finished_at'] ? :finished : :processing
        LOGGER.debug "Status for project #{id}: #{status}"
        status
      end
    end

    def download
      if status == :finished
        client.handle_response(client.api.get("code/#{id}.zip")) do |response|
          LOGGER.info "Downloading source files for #{id}..."
          temp = Tempfile.new(%w(jscrambler .zip))
          temp.write(response)
          temp.close
          JScrambler::Archiver.new(temp).unzip(client.config['filesDest'])
        end
        delete if client.config['deleteProject']
        true
      else
        false
      end
    end

    def delete
      client.handle_response(client.api.delete("code/#{id}.zip")) do |json_response|
        is_deleted = json_response['deleted']
        LOGGER.info "Deleted project #{id}" if is_deleted
        is_deleted
      end
    end
  end
end
