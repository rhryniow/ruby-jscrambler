require 'spec_helper'

describe JScrambler::Archiver do

  let(:files) { [Tempfile.new('file1'), Tempfile.new('file2')] }

  describe '#initialize' do

    subject { described_class.new(files.map(&:path)) }

    it 'should create a temporary file' do
      expect(subject.zipfile).to be_a Tempfile
    end
  end

  describe '#zip' do

    subject { described_class.new(files.map(&:path)).zip }

    it 'should generate a zipfile' do
      expect(File.exists?(subject)).to be true
    end
  end
end
