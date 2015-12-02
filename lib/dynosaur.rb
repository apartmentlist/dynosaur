require 'dynosaur/version'

require 'dynosaur/process'
require 'dynosaur/process/heroku'
require 'dynosaur/process/heroku/finder'
require 'dynosaur/process/local'
require 'dynosaur/process/local/finder'

require 'dynosaur/utils/os'
require 'dynosaur/utils/rake_command'

# Spin up a rake task in a separate process
module Dynosaur
end
