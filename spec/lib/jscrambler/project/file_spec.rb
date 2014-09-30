require 'spec_helper'

describe JScrambler::Project::File do

  let(:client) { JScrambler::Client.new }
  let(:options) {
    {
        'id' => '12345',
        'project_id' => '1234',
        'extension' => 'html',
        'filename' => 'index.html',
        'size' => '45'
    }
  }

  before do
    @stubbed_api = Faraday::Adapter::Test::Stubs.new

    api = Faraday.new do |builder|
      builder.use       JScrambler::Middleware::DefaultParams
      builder.use       JScrambler::Middleware::Authentication
      builder.request   :multipart
      builder.request   :url_encoded
      builder.adapter   :test, @stubbed_api
    end
    allow(client).to receive(:api).and_return(api)
    allow(JScrambler::Client).to receive(:new).and_return(client)
  end

  describe '#download' do

    before do
      @stubbed_api.get('code/1234/12345.html') { |env| [ 200, {}, File.open('spec/fixtures/samples/index.html').read ]}
    end

    subject { described_class.new(options, client).download }

    it 'should return turn if everything went ok' do
      expect(subject).to be true
    end
  end
end
