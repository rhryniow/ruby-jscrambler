require 'spec_helper'

describe JScrambler::Middleware::Authentication do

  let(:file_0) { Tempfile.new(%w(file1 .zip)) }
  let(:app) { double('app', call: nil) }

  before do
    # @api = Faraday.new do |builder|
    #   builder.use     JScrambler::Middleware::Timestamp
    #   builder.use     JScrambler::Middleware::HmacSignature
    #   builder.request :multipart
    #   builder.request :url_encoded
    #   builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
    #     stub.get('/code.json') { |env| [ 200, {}, 'sup?!' ]}
    #     stub.delete('/code.json') { |env| [ 200, {}, 'sup?!' ]}
    #     stub.put('/code.json') { |env| [ 200, {}, 'sup?!' ]}
    #     stub.post('/code.json') { |env| [ 200, {}, 'sup?!' ]}
    #   end
    # end
  end

  subject { described_class.new(app) }

  context 'when dealing with get requests' do
    let(:payload) { { :access_key => '1234', timestamp: '2014-09-28T18:05:24Z' } }
    let(:env) { double('env', method: :get, body: payload, url: '/code.json') }

    it 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq '66LvBFIvTRI2TzNcH4mh0MqFtHxNx2mEFoGe2n6TK3Q='
    end
  end

  context 'when dealing with post requests' do
    let(:payload) {
      {
          file_0: Faraday::UploadIO.new(file_0.path, 'application/octet-stream'),
          access_key: '1234',
          timestamp: '2014-09-28T18:05:24Z'
      }
    }
    let(:env) { double('env', method: :post, body: payload, url: '/code.json') }

    it 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'butCKe/+70LO7m/SXY5OncAaGtTQ3iTZfqR7FHBM5aE='
    end
  end

  context 'when dealing with put requests' do
    let(:payload) {
      {
          file_0: Faraday::UploadIO.new(file_0.path, 'application/octet-stream'),
          access_key: '1234',
          timestamp: '2014-09-28T18:05:24Z'
      }
    }
    let(:env) { double('env', method: :put, body: payload, url: '/code.json') }

    it 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'ugIIfT5l9s9cgdg5PeMgbqQqL+VnMVGqDLYAjWRGA2M='
    end
  end

  context 'when dealing with delete requests' do
    let(:payload) { { :access_key => '1234', timestamp: '2014-09-28T18:05:24Z' } }
    let(:env) { double('env', method: :delete, body: payload, url: '/code.json') }

    it 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq '8fyRNV0inEI8nYysOYB5TyeneIbRTbMyMv/94FrFwPA='
    end
  end
end
