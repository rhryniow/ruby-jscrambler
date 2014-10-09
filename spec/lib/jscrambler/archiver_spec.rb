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

    context 'when dealing with globs' do

      subject { instance.zip(['spec/fixtures/samples/*']) }

      it 'should generate a zipfile' do
        expect(File.exists?(subject)).to be true
      end
    end
  end

  describe '#unzip' do

    let(:to_path) { Dir.mktmpdir }

    subject { instance.unzip(to_path) }

    context 'when extracting a file' do

      it 'should work :)' do
        instance.zip(files.map(&:path))

        subject.each do |file|
          expect(File.exists?(File.join(to_path, File.basename(file)))).to be true
        end
      end

      it 'should maintain folder structure with **/*' do
        instance.zip(['spec/fixtures/samples/**/*'])

        subject

        expect(File.exists?(File.join(to_path, 'folder'))).to be true
        expect(File.exists?(File.join(to_path, 'folder/hello.js'))).to be true
        expect(File.exists?(File.join(to_path, 'index.html'))).to be true
        expect(File.exists?(File.join(to_path, 'hello.js'))).to be true
      end

      it 'should maintain folder structure with *.js' do
        instance.zip(['spec/fixtures/samples/*.js'])

        subject

        expect(File.exists?(File.join(to_path, 'folder'))).to be false
        expect(File.exists?(File.join(to_path, 'folder/hello.js'))).to be false
        expect(File.exists?(File.join(to_path, 'index.html'))).to be false
        expect(File.exists?(File.join(to_path, 'hello.js'))).to be true
      end
    end

    context 'when dealing with errors' do

      before do
        instance.zip(files.map(&:path))
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
end
