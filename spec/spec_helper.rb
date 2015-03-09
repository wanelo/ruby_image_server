require 'simplecov'
SimpleCov.start

pid = Process.pid
SimpleCov.at_exit do
  SimpleCov.result.format! if Process.pid == pid
end

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require File.expand_path('../fixtures.rb', __FILE__)
require File.expand_path('../resources.rb', __FILE__)
