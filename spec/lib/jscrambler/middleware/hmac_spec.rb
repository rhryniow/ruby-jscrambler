require 'spec_helper'

describe JScrambler::Middleware::HmacSignature do

  let(:file1) { Tempfile.new(%w(file1 .jpg)) }
  let(:file2) { Tempfile.new(%w(file2 .jpg)) }
  let(:payload) {
    {
        :files => [Faraday::UploadIO.new(file1.path, 'image/jpeg'), Faraday::UploadIO.new(file2.path, 'image/jpeg')],
        :access_token => '1234'
    }
  }

  before do
    @api = Faraday.new do |builder|
      builder.use     JScrambler::Middleware::HmacSignature
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/code.json', payload) { |env| [ 200, {}, 'sup?!' ]}
      end
    end
  end

  it 'should sign all requests with a hmac signature' do
    # a=@api.post('/code.json', payload)
    # require 'byebug'; byebug
  end
end
