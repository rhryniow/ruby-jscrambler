require 'spec_helper'

describe JScrambler::Archiver do

  let(:files) { [Tempfile.new('file1'), Tempfile.new('file2')] }
  let(:instance) { described_class.new }

  describe '#initialize' do

    subject { instance }

    it 'should create a temporary file' do
      expect(subject.zipfile).to be_a Tempfile
    end
  end

  describe '#zip' do

    subject { instance.zip(files.map(&:path)) }

    it 'should generate a zipfile' do
      expect(File.exists?(subject)).to be true
    end
  end

  describe '#unzip' do

    let(:to_path) { Dir.mktmpdir }

    before do
      instance.zip(files.map(&:path))
    end

    subject { instance.unzip(to_path) }

    it 'should generate a zipfile' do
      subject.each do |file|
        expect(File.exists?(File.join(to_path, File.basename(file)))).to be true
      end
    end

    it 'should raise an error when destination path is empty' do
      expect{instance.unzip('')}.to raise_error(JScrambler::InvalidPath)
    end

    it 'should raise an error when destination path is nil' do
      expect{instance.unzip(nil)}.to raise_error(JScrambler::InvalidPath)
    end

    it 'should raise an error when destination path is invalid' do
      expect{instance.unzip('/tmp/helloadasdasd')}.to raise_error(JScrambler::InvalidPath)
    end
  end
end
