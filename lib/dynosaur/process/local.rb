# Start the rake task in a local process
module Dynosaur
  class Process
    class Local < Process
      def start
        pid = ::Process.spawn(rake_command.to_s)
        ::Process.detach(pid)
        pid
      end
    end
  end
end
