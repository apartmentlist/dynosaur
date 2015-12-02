# Utility methods for interacting with the underlying OS
module Dynosaur
  module Utils
    module OS
      class << self
        # @return [Array] Object instances, which respond to #command, for all
        #   locally running processes returned by the ps command
        def structured_ps
          ps_array = ps.split("\n").map(&:split)
          keys = ps_array.shift
          command_index = keys.find_index { |key| key == 'CMD' }
          ps_array.map do |values|
            Struct.new(:command).new(values[command_index])
          end
        end

        private

        def ps
          `ps`
        end
      end
    end
  end
end
