require 'shellwords'

module Dynosaur
  class Process
    def initialize(task:, args: [], opts: {})
      @task = task
      @args = args
      after_initialize(opts)
    end

    def start
      fail NotImplementedError, 'This method must be implemented in a subclass'
    end

    private

    attr_reader :args, :task

    def after_initialize(opts)
      # Do nothing so subclasses don't have to override if they want a no-op
    end

    def rake_command
      formatted_args = args.map do |arg|
        arg.respond_to?(:shellescape) ? arg.shellescape : arg
      end.join(',')
      task_with_args = args.empty? ? task : "#{task}[#{formatted_args}]"
      "rake #{task_with_args} --trace"
    end
  end
end
