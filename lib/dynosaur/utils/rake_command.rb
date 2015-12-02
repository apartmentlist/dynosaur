# Utility methods for generating and parsing rake command
module Dynosaur
  module Utils
    class RakeCommand
      PARSE_REGEX = /\brake\s+([\w:]+)(\[.*\])?/

      attr_reader :task, :args

      # @param command [String] the command to test for validity
      # @return [true|false] true iff the string is a valid rake command
      def self.valid?(command)
        !(command =~ PARSE_REGEX).nil?
      end

      # @param command [String] the command to parse
      # @return [RakeCommand] an instance that represents the command being parsed
      # @raise [ArgumentError] if the command is not a valid rake command
      def self.parse(command)
        match = command.match(PARSE_REGEX)
        raise ArgumentError, %Q(Invalid rake command: "#{command}") unless match
        task = match[1]
        args = match[2] ? match[2].tr('[]', '').split(',') : []
        new(task: task, args: args)
      end

      def initialize(task:, args: [])
        @task = task
        @args = args
      end

      # @return [String] the full rake command, including arguments
      def to_s
        formatted_args = args.map do |arg|
          arg.is_a?(String) ? arg.shellescape : arg
        end.join(',')
        task_with_args = args.empty? ? task : "#{task}[#{formatted_args}]"
        "rake #{task_with_args} --trace"
      end

      def ==(other)
        task == other.task && args.map(&:to_s) == other.args.map(&:to_s)
      end
    end
  end
end
