require 'shellwords'

module Dynosaur
  class Process
    def initialize(task:, args: [], opts: {})
      @rake_command = Utils::RakeCommand.new(task: task, args: args)
      after_initialize(opts)
    end

    def running?
      klass = self.class::Finder
      finder = klass.new(rake_command: rake_command)
      finder.exists?
    end

    def start
      fail NotImplementedError, 'This method must be implemented in a subclass'
    end

    private

    attr_reader :rake_command

    def after_initialize(opts)
      # Do nothing so subclasses don't have to override if they want a no-op
    end
  end
end
