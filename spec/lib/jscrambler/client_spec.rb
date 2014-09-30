require 'spec_helper'

describe JScrambler::Client do

  describe '#new_project' do
    let(:client)  { JScrambler::Client.new }
    let(:files)   { [Tempfile.new('file1'), Tempfile.new('file2')] }

    before do
      @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/post/code.json').read ]}
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

    subject { client.new_project }

    it 'should create a new project if api request successfull' do
      expect(subject).to be_a JScrambler::Project
    end

    context 'when api returns an error' do

      before do
        @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post('code.json') { |env| [ 401, {}, File.open('spec/fixtures/api/post/error.json').read ]}
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

      it 'should return an api error in case of error' do
        expect{subject}.to raise_error(JScrambler::ApiError)
      end
    end
  end

  describe '#projects' do
    let(:client)  { JScrambler::Client.new }
    let(:files)   { [Tempfile.new('file1'), Tempfile.new('file2')] }

    before do
      @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/code.json').read ]}
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

    subject { client.projects }

    it 'should return a list of projects' do
      expect(subject.first).to be_a JScrambler::Project
    end

    context 'when api returns an error' do

      before do
        @stubbed_api = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('code.json') { |env| [ 401, {}, File.open('spec/fixtures/api/get/error.json').read ]}
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

      it 'should return an api error in case of error' do
        expect{subject}.to raise_error(JScrambler::ApiError)
      end
    end
  end
end
