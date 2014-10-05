require 'abbrev'

module JScrambler
  class Archiver

    attr_accessor :zipfile

    def initialize(zipfile=Tempfile.new(%w(jscrambler .zip)))
      @zipfile = zipfile
    end

    def zip(paths)

      File.delete(zipfile.path) if File.exists?(zipfile.path)

      Zip::File.open(zipfile.path, Zip::File::CREATE) do |zip_handler|
        paths.each do |path|
          expanded_glob = Dir.glob(path)
          common_path = common_path(expanded_glob + [path])
          expanded_glob.each do |file_path|
            internal_file_path = file_path.gsub(File.join(common_path, ''), '')
            zip_handler.add(internal_file_path, file_path)
          end
        end
      end
      zipfile
    end

    def unzip(to_path, options={})
      raise JScrambler::InvalidPath, 'When unzipping a file a destination path is required' unless File.directory?(to_path.to_s)

      options[:overwrite] ||= true

      files = []
      Zip::File.open(zipfile.path) do |zip_file|
        zip_file.each do |entry|
          to_file_path = File.join(to_path, entry.name)
          files << to_file_path
          File.delete(to_file_path) if File.exist?(to_file_path) && options[:overwrite]
          entry.extract(to_file_path)
        end
      end
      files
    end

    private

    def common_path(dirs)
      common_prefix = dirs.abbrev.keys.min_by {|key| key.length}.chop
      common_prefix.sub(%r{/[^/]*$}, '')
    end
  end
end
