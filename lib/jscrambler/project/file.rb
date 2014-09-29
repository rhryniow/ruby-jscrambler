module JScrambler
  class Project::File

    attr_reader :id, :extension, :filename, :size, :client

    def initialize(options={}, client)
      raise ArgumentError, 'Cannot create file without ID' unless options['id']
      @id = options['id']
      @client = client
      @extension = options['extension']
      @filename = options['filename']
      @size = options['size']
    end
  end
end
