require 'dynosaur/client/heroku_client'

require_relative '../process'

module Dynosaur
  class Process
    class Heroku < Process
      def start
        app_name = Dynosaur::Client::HerokuClient.app_name
        dyno_accessor = Dynosaur::Client::HerokuClient.client.dyno
        response =
          dyno_accessor.create(app_name, command: rake_command, attach: false)
        response['name']
      end
    end
  end
end
