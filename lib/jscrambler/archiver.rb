module JScrambler
  class Archiver

    attr_accessor :files
    attr_accessor :zipfile

    def initialize(files, zipfile=Tempfile.new(%w(jscrambler .zip)))
      @files, @zipfile = files, zipfile
    end

    def zip
      Zip::File.open(zipfile.path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          filename = File.basename(file)
          zipfile.add(filename, file)
        end
        # zipfile.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
      end
      zipfile.path
    end

    def unzip(to_path)
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
