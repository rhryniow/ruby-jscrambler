module JScrambler
  module Middleware
    class HmacSignature

      def initialize(app, options = {})
        @app, @options, @config = app, options, JScrambler::Config.new.to_hash
      end

      def call(env)
        env.body[:signature] = hmac_params_signature(env)
        @app.call(env)
      end

      private

      def hmac_params_signature(env)
        key = @config['keys']['secretKey'].to_s.upcase
        data = generate_data(env)
        Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)).strip
      end

      def generate_data(env)
        data = []
        data << env.method.to_s.upcase
        data << @config['host'].to_s.downcase
        data << env.url.to_s
        data << generate_query_string(env)
        data.join(';')
      end

      def generate_query_string(env)
        params_copy = env.body.clone
        params_copy = sort_parameters(params_copy)

        if [:get, :delete].include? env.method
          URI.encode_www_form(params_copy)
        else
          params_copy = add_file_params(params_copy)
          URI.encode(params_copy.map{|k,v| "#{k}=#{v}"}.join('&'))
        end
      end

      def sort_parameters(params)
        Hash[params.sort_by{|key, _| key}]
      end

      def add_file_params(params)
        if params[:files].kind_of? Array
          file_index = 0
          params.delete(:files).each do |file|
            params["file_#{file_index}".to_sym] = OpenSSL::Digest::MD5.hexdigest(File.read(file.local_path))
            file_index += 1
          end
        end
        params
      end
    end
  end
end
