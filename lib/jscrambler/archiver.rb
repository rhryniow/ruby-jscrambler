module JScrambler
  class Archiver

    attr_accessor :files
    attr_accessor :zipfile

    def initialize(files)
      @files, @zipfile = files, Tempfile.new(%w(jscrambler .zip))
    end

    def zip
      Zip::File.open(@zipfile.path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          filename = File.basename(file)
          zipfile.add(filename, file)
        end
        # zipfile.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
      end
      @zipfile.path
    end

    def unzip

    end
  end
end
