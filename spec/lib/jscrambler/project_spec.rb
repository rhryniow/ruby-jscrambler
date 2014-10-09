require 'spec_helper'

describe JScrambler::Project do

  let(:client) { JScrambler::Client.new }
  let(:options) {
    {
        'id' => '1234',
        'sources' => [{'id'=>'32a2afa05c871a4ac2e4cb804623f8d574115148', 'extension'=>'js', 'filename'=>'hello.js', 'size'=>29}, {'id'=>'6393236cb4c751210d55183e61ab930bc39b3e6a', 'extension'=>'html', 'filename'=>'index.html', 'size'=>89}],
        'received_at' => '2014-09-29 19:26:36',
        'finished_at' => '2014-09-29 19:26:46',
        'js_files' => '1',
        'html_files' => '3'
    }
  }

  subject { described_class.new(options, client) }

  describe '#initialize' do
    context 'when not providing an ID' do
      let(:options) { {} }
      it 'should raise an error' do
        expect{subject}.to raise_error ArgumentError
      end
    end
  end

  describe '#files' do
    it 'should create an array of JScrambler::Project::File' do
      expect(subject.files.map(&:class).uniq.count).to eq 1
      expect(subject.files.map(&:class).uniq.first).to eq JScrambler::Project::File
    end
  end

  describe '#status' do

    context 'when finished' do
      before do
        @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('code/1234.json') { |env| [ 200, {}, '{"finished_at":"2014-09-29 18:17:21"}' ]}
        end

        api = Faraday.new do |builder|
          builder.use       JScrambler::Middleware::DefaultParams
          builder.use       JScrambler::Middleware::Authentication
          builder.request   :multipart
          builder.request   :url_encoded
          builder.adapter   :test, @stubbed_api
        end

        allow(client).to receive(:api).and_return(api)
      end

      it 'should return correct status' do
        expect(subject.status).to eq :finished
      end
    end

    context 'when processing' do
      before do
        @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('code/1234.json') { |env| [ 200, {}, '{"finished_at":null}' ]}
        end

        api = Faraday.new do |builder|
          builder.use       JScrambler::Middleware::DefaultParams
          builder.use       JScrambler::Middleware::Authentication
          builder.request   :multipart
          builder.request   :url_encoded
          builder.adapter   :test, @stubbed_api
        end

        allow(client).to receive(:api).and_return(api)
      end

      it 'should return correct status' do
        expect(subject.status).to eq :processing
      end
    end
  end

  describe '#download' do
    before do
      @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('code/1234.zip') { |env| [ 200, {}, "PK\x03\x04\x14\x00\b\x00\b\x00H\xAF=E\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\n\x00\x00\x00index.html\xB3QL\xC9O.\xA9,HU\xC8(\xC9\xCD\xB1\xE3\xB2\x81Q\xA9\x89)v\\\n@`S\x9C\\\x94YP\xA2P\\\x94l\xAB\x94\x91\x9A\x93\x93\xAF[\x9E_\x94\x93\xA2\x97U\xACdg\xA3\x0F\x91\x05\xEA\xD0\x87h\x01\xD2`\x13\x00PK\a\b\e\xE9\x94\x96E\x00\x00\x00Y\x00\x00\x00PK\x03\x04\x14\x00\b\x00\b\x00H\xAF=E\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\b\x00\x00\x00hello.jsK\xCE\xCF+\xCE\xCFI\xD5\xCB\xC9O\xD7P\xF7H\xCD\xC9\xC9W(\xCF/\xCAIQT\xD7\xB4\x06\x00PK\a\b\x19\xA8\x9E\f\x1E\x00\x00\x00\x1C\x00\x00\x00PK\x01\x02\x14\x00\x14\x00\b\x00\b\x00H\xAF=E\e\xE9\x94\x96E\x00\x00\x00Y\x00\x00\x00\n\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00index.htmlPK\x01\x02\x14\x00\x14\x00\b\x00\b\x00H\xAF=E\x19\xA8\x9E\f\x1E\x00\x00\x00\x1C\x00\x00\x00\b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00}\x00\x00\x00hello.jsPK\x05\x06\x00\x00\x00\x00\x02\x00\x02\x00n\x00\x00\x00\xD1\x00\x00\x00\x00\x00" ]}
      end

      api = Faraday.new do |builder|
        builder.use       JScrambler::Middleware::DefaultParams
        builder.use       JScrambler::Middleware::Authentication
        builder.request   :multipart
        builder.request   :url_encoded
        builder.adapter   :test, @stubbed_api
      end

      allow(client).to receive(:api).and_return(api)
    end

    context 'when finished' do

      before do
        allow(subject).to receive(:status).and_return(:finished)
      end

      it 'should return true' do
        expect(subject.download).to be true
      end
    end

    context 'when not finshed' do

      before do
        allow(subject).to receive(:status).and_return(:processing)
      end

      it 'should return false' do
        expect(subject.download).to be false
      end
    end
  end
end
