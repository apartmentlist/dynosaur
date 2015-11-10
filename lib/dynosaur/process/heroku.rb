require 'dynosaur/client/heroku_client'

require_relative '../process'

# Start a detached rake task on a one-off dyno
module Dynosaur
  class Process
    class Heroku < Process
      # Valid dyno sizes under Heroku's new pricing model
      module Size
        PERFORMANCE_M = 'performance-m'.freeze
        PERFORMANCE_L = 'performance-l'.freeze
        STANDARD_1X = 'standard-1X'.freeze
        STANDARD_2X = 'standard-2X'.freeze
      end

      # Valid dyno sizes under Heroku's old pricing model
      module DeprecatedSize
        PERFORMANCE = 'PX'.freeze
        STANDARD_1X = '1X'.freeze
        STANDARD_2X = '2X'.freeze
      end

      def start
        app_name = Dynosaur::Client::HerokuClient.app_name
        dyno_accessor = Dynosaur::Client::HerokuClient.client.dyno
        create_opts = { command: rake_command, attach: false }
        create_opts[:size] = size if size
        response = dyno_accessor.create(app_name, create_opts)
        response['name']
      end

      private

      attr_reader :size

      def after_initialize(opts)
        @size = opts[:size]
      end
    end
  end
end
