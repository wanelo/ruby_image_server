module RubyImageServer
  module S3
    class FastlyLogParser
      def initialize(io)
        @iostream = io
      end

      # Parse the Fastly log file and return a list of image hashes
      # @return [Array] An array of hashes containg namespace and image_hash per image property (empty array if none found)
      def image_hashes
        @iostream.each_line.flat_map do |line|
          match = line.match(%r{(\w+)/((?:\w{3}/){3}\w{23})})
          next unless match
          {
            namespace: match[1],
            image_hash: match[2].gsub('/', '')
          }
        end.compact
      end
    end
  end
end
