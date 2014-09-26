require 'spec_helper'

describe JScrambler::Archiver do

  let(:files) { [Tempfile.new('file1'), Tempfile.new('file2')] }
  let(:instance) { described_class.new(files.map(&:path)) }

  describe '#initialize' do

    subject { instance }

    it 'should create a temporary file' do
      expect(subject.zipfile).to be_a Tempfile
    end
  end

  describe '#zip' do

    subject { instance.zip }

    it 'should generate a zipfile' do
      expect(File.exists?(subject)).to be true
    end
  end

  describe '#unzip' do

    let(:to_path) { Dir.mktmpdir }

    before do
      instance.zip
    end

    subject { instance.unzip(to_path) }

    it 'should generate a zipfile' do
      subject.each do |file|
        expect(File.exists?(File.join(to_path, File.basename(file)))).to be true
      end
    end
  end
end
