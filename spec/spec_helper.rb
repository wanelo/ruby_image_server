require 'simplecov'
require 'aws-sdk'
SimpleCov.start

pid = Process.pid
SimpleCov.at_exit do
  SimpleCov.result.format! if Process.pid == pid
end

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require File.expand_path('../fixtures.rb', __FILE__)
require File.expand_path('../resources.rb', __FILE__)

RSpec.configure do |c|
  c.include RubyImageServer::Test::Fixtures
end
