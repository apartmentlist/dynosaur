# Utility methods for interacting with the underlying OS
module Dynosaur
  module Utils
    module OS
      class << self
        # @return [Array] Object instances, which respond to #command, for all
        #   locally running processes returned by the ps command
        def structured_ps
          ps_array = command_ps.split("\n").map(&:strip)
          ps_array.shift # Remove the header row
          ps_array.map do |command|
            Struct.new(:command).new(command)
          end
        end

        private

        def command_ps
          `ps -o command`
        end
      end
    end
  end
end
