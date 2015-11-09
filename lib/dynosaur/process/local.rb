require_relative '../process'

module Dynosaur
  class Process
    class Local < Process
      def start
        pid = ::Process.spawn(rake_command)
        ::Process.detach(pid)
        pid
      end
    end
  end
end
