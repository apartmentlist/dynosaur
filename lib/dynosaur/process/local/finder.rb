# Detects if a running process is currently executing the rake command
module Dynosaur
  class Process
    class Local
      class Finder
        def initialize(rake_command:)
          @rake_command = rake_command
        end

        def exists?
          Utils::OS.structured_ps.any? do |process|
            Utils::RakeCommand.valid?(process.command) &&
              Utils::RakeCommand.parse(process.command) == rake_command
          end
        end

        private

        attr_reader :rake_command
      end
    end
  end
end
