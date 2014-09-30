module JScrambler
  class Project::File

    attr_reader :id, :project_id, :extension, :filename, :size, :client

    def initialize(options={}, client)
      raise ArgumentError, 'Cannot create file without ID' unless options['id']
      @id = options['id']
      @project_id = options['project_id']
      @client = client
      @extension = options['extension']
      @filename = options['filename']
      @size = options['size']
    end

    def download
      client.handle_response(client.api.get("code/#{project_id}/#{id}.#{extension}")) do |response|
        to_file_path = File.join(client.config['filesDest'], "#{filename}")
        File.delete(to_file_path) if File.exist?(to_file_path)
        file_handler = File.open(to_file_path, 'w')
        file_handler.write(response)
        file_handler.close
      end
      true
    end
  end
end
