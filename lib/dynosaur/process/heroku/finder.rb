# Detects if a running dyno is currently executing the rake command
module Dynosaur
  class Process
    class Heroku
      class Finder
        def initialize(rake_command:, client: Client::HerokuClient.client)
          @rake_command = rake_command
          @client = client
        end

        def exists?
          one_off_dynos.any? do |dyno|
            Utils::RakeCommand.valid?(dyno.command) &&
              Utils::RakeCommand.parse(dyno.command) == rake_command
          end
        end

        private

        attr_reader :rake_command, :client

        # @return [Array] Object instances, which respond to #command, for all
        #   locally one off dynos
        def one_off_dynos
          app_name = Dynosaur::Client::HerokuClient.app_name
          dynos = client.dyno.list(app_name).map do |response|
            Struct.new(:type, :command).new(response['type'], response['command'])
          end
          dynos.select { |dyno| dyno.type == 'run' }
        end
      end
    end
  end
end
