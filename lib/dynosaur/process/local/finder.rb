require 'sys/proctable'

# Detects if a running process is currently executing the rake command
module Dynosaur
  class Process
    class Local
      class Finder
        def initialize(rake_command:)
          @rake_command = rake_command
        end

        def exists?
          Sys::ProcTable.ps.map(&:cmdline).any? do |command|
            Utils::RakeCommand.valid?(command) &&
              Utils::RakeCommand.parse(command) == rake_command
          end
        end

        private

        attr_reader :rake_command
      end
    end
  end
end
