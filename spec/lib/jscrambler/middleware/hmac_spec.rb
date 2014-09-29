require 'spec_helper'

describe JScrambler::Middleware::HmacSignature do

  let(:file1) { Tempfile.new(%w(file1 .jpg)) }
  let(:file2) { Tempfile.new(%w(file2 .jpg)) }
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

    xit 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'ur8xL6Dg+ReT4g4SA+Tz/WViOej4hfCRZZb0CWMblIc='
    end
  end

  context 'when dealing with post requests' do
    let(:payload) {
      {
          files: [Faraday::UploadIO.new(file1.path, 'image/jpeg'), Faraday::UploadIO.new(file2.path, 'image/jpeg')],
          access_key: '1234',
          timestamp: '2014-09-28T18:05:24Z'
      }
    }
    let(:env) { double('env', method: :post, body: payload, url: '/code.json') }

    xit 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'hqTZHnzMD7Z8nxrEqpWRzzIXVi4qkFcXjEmuolyZN6g='
    end
  end

  context 'when dealing with put requests' do
    let(:payload) {
      {
          files: [Faraday::UploadIO.new(file1.path, 'image/jpeg'), Faraday::UploadIO.new(file2.path, 'image/jpeg')],
          access_key: '1234',
          timestamp: '2014-09-28T18:05:24Z'
      }
    }
    let(:env) { double('env', method: :put, body: payload, url: '/code.json') }

    xit 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'vfDnATXVoRQOXiFNkozxgWyc8nI5ZOqKd5Zo8b1taOA='
    end
  end

  context 'when dealing with delete requests' do
    let(:payload) { { :access_key => '1234', timestamp: '2014-09-28T18:05:24Z' } }
    let(:env) { double('env', method: :delete, body: payload, url: '/code.json') }

    xit 'should sign request with a hmac signature' do
      subject.call(env)
      expect(env.body[:signature]).to eq 'p0WpdoL52F70tCOHliiovGmENZ3Uw0bLaXR6bh3nyU4='
    end
  end
end
