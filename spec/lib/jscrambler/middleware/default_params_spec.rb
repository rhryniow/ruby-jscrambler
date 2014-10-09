require 'spec_helper'

describe JScrambler::Middleware::DefaultParams do

  let(:app) { double('app', call: nil) }
  let(:payload) { {} }
  let(:env) { double('env', method: :get, body: payload, url: '/code.json') }

  subject { described_class.new(app) }

  it 'should delete files param' do
    subject.call(env)
    expect(env.body[:files]).to be_nil
  end

  it 'should define access_key param' do
    subject.call(env)
    expect(env.body[:access_key]).to eq 'ACCESS_KEY'
  end

  it 'should define timestamp param' do
    subject.call(env)
    expect(env.body[:timestamp]).to be_a String
  end

  context 'when sending files param' do
    let(:file_0) { Tempfile.new(%w(file1 .zip)) }
    let(:payload) { { files: [Faraday::UploadIO.new(file_0.path, 'application/octet-stream')] } }

    it 'should split files in separate params' do
      subject.call(env)
      expect(env.body[:file_0]).to be_a Faraday::UploadIO
    end
  end
end
