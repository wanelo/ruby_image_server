def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module RubyImageServer
  module Test
    # Fixtures are static content required for testing. This may include JSON bodies
    # returned from RESTful APIs, text files that need to be parsed, etc.
    module Fixtures
      def fastly_404_log
        IO.read(fixture('404.log'))
      end
    end
  end
end
