module JScrambler
  module Middleware
    class DefaultParams

      def initialize(app, options = {})
        @app, @options, @config = app, options, JScrambler::Config.new.to_hash
      end

      def call(env)
        file_index = 0
        env.body.delete(:files).to_a.each do |file|
          env.body["file_#{file_index}".to_sym] = file
          file_index += 1
        end
        env.body[:access_key] = @config['keys']['accessKey']
        env.body[:timestamp] = Time.now.utc.iso8601
        @app.call(env)
      end
    end
  end
end

