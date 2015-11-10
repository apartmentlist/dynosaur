require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :echo, [:arg1, :arg2] do |_task, args|
  puts %Q(ARG1: "#{args[:arg1]}")
  puts %Q(ARG2: "#{args[:arg2]}")
end

task :sleep, [:duration] do |_task, args|
  File.open('/tmp/sleep', 'w') do |file|
    file.puts "Sleeping"
    args[:duration].to_i.times do
      sleep(1)
      file.print('.')
      file.flush
    end
    file.print("\n")
    file.puts "Awake"
    file.flush
  end
end
