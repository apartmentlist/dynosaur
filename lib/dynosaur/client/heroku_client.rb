require 'platform-api'

module Dynosaur
  module Client
    module HerokuClient
      def self.config
        @config ||= Config.new
      end

      def self.configure
        yield config if block_given?
      end

      def self.client
        PlatformAPI.connect_oauth(api_key)
      end

      def self.app_name
        config.app_name || fail('app_name must be set in the config')
      end

      def self.api_key
        config.api_key || fail('api_key must be set in the config')
      end
      private_class_method :api_key

      private

      Config = Struct.new(:api_key, :app_name)
    end
  end
end
