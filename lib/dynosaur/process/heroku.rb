require 'dynosaur/client/heroku_client'

# Start a detached rake task on a one-off dyno
module Dynosaur
  class Process
    class Heroku < Process
      # Valid dyno sizes under Heroku's new pricing model
      module Size
        STANDARD_1X = 'standard-1X'.freeze
        STANDARD_2X = 'standard-2X'.freeze
        PERFORMANCE_M = 'performance-m'.freeze
        PERFORMANCE_L = 'performance-l'.freeze
      end

      # Valid dyno sizes under Heroku's old pricing model
      module DeprecatedSize
        STANDARD_1X = '1X'.freeze
        STANDARD_2X = '2X'.freeze
        PERFORMANCE = 'PX'.freeze
      end

      def start
        app_name = Dynosaur::Client::HerokuClient.app_name
        client = Dynosaur::Client::HerokuClient.client
        create_opts = { command: rake_command.to_s, attach: false }
        create_opts[:attach] = attach if attach
        create_opts[:size] = size if size
        response = client.dyno.create(app_name, create_opts)
        response['name']
      end

      private

      attr_reader :size, :attach

      def after_initialize(opts)
        @size = opts[:size]
        @attach = opts[:attach]
      end
    end
  end
end
