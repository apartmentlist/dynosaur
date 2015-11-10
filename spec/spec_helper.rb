require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'dynosaur'

Dynosaur::Client::HerokuClient.configure do |config|
  config.app_name = 'dynosaur-test-app'
  config.api_key = 'dynosaur-test-key'
end
