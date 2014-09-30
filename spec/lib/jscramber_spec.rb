require 'spec_helper'

describe JScrambler do

  let(:client) { JScrambler::Client.new }

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

  describe '.upload_code' do

    subject { JScrambler.upload_code }

    before do
      @stubbed_api.post('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/post/code.json').read ]}
    end

    it 'should create a new instance of a JScrambler::Project' do
      expect(subject).to be_a JScrambler::Project
    end
  end

  describe '.poll_project' do

    context 'when providing a project object' do

      let(:project) { JScrambler::Project.new({'id' => '1234'}, client) }

      before do
        @stubbed_api.get('code/1234.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/project.json').read ]}
      end

      subject { JScrambler.poll_project(project) }

      it 'should return true' do
        expect(subject).to be true
      end
    end

    context 'when providing a project id' do

      let(:project) { '1234' }

      before do
        @stubbed_api.get('code/1234.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/project.json').read ]}
        @stubbed_api.get('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/code.json').read ]}
      end

      subject { JScrambler.poll_project(project) }

      it 'should return true' do
        expect(subject).to be true
      end
    end

    context 'when project not found' do

      context 'and a project id was provided' do

        let(:project) { 'not_found' }

        before do
          @stubbed_api.get('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/code.json').read ]}
        end

        subject { JScrambler.poll_project(project) }

        it 'should raise an exception' do
          expect{subject}.to raise_error JScrambler::ProjectNotFound
        end
      end
    end

    context 'when timming out on retries' do

      let(:project) { JScrambler::Project.new({'id' => '1234'}, client) }

      before do
        @stubbed_api.get('code/1234.json') { |env|
          [ 200, {}, File.open('spec/fixtures/api/get/project_not_finished.json').read ]
        }
        stub_const('JScrambler::POLLING_MAX_RETRIES', 1)
        stub_const('JScrambler::POLLING_FREQUENCY', 0.05)
      end

      subject { JScrambler.poll_project(project) }

      it 'should raise an exception' do
        expect{subject}.to raise_error JScrambler::ApiError
      end
    end
  end

  describe '.projects' do

    before do
      @stubbed_api.get('code.json') { |env| [ 200, {}, File.open('spec/fixtures/api/get/code.json').read ]}
    end

    subject { JScrambler.projects }

    it 'should return a list of projects' do
      expect(subject).to be_a Array
      expect(subject.first).to be_a JScrambler::Project
    end
  end
end
