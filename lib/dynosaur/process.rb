module Dynosaur
  class Process
    def initialize(task:, args: [])
      @task = task
      @args = args
    end

    def start
      fail NotImplementedError, 'This method must be implemented in a subclass'
    end

    private

    attr_reader :args, :task

    def rake_command
      formatted_args = args.map(&:inspect).join(',')
      task_with_args = args.empty? ? task : "#{task}[#{formatted_args}]"
      "rake #{task_with_args} --trace"
    end
  end
end
