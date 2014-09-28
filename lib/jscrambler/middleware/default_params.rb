module JScrambler
  module Middleware
    class DefaultParams

      def initialize(app, options = {})
        @app, @options, @config = app, options, JScrambler::Config.new.to_hash
      end

      def call(env)
        env.body[:access_key] = @config['keys']['accessKey']
        env.body[:timestamp] = Time.now.utc.iso8601
        @app.call(env)
      end
    end
  end
end

