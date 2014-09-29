module JScrambler
  class Archiver

    attr_accessor :zipfile

    def initialize(zipfile=Tempfile.new(%w(jscrambler .zip)))
      @zipfile = zipfile
    end

    def zip(files)
      Zip::File.open(zipfile.path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          filename = File.basename(file)
          zipfile.add(filename, file)
        end
      end
      zipfile
    end

    def unzip(to_path)
      raise JScrambler::InvalidPath, 'When unzipping a file a destination path is required' unless File.directory?(to_path.to_s)
      files = []
      Zip::File.open(zipfile.path) do |zip_file|
        zip_file.each do |entry|
          to_file_path = File.join(to_path, entry.name)
          files << to_file_path
          entry.extract(to_file_path)
        end
      end
      files
    end
  end
end
