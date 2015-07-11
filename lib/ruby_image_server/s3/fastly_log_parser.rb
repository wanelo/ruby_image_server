module RubyImageServer
  module S3
    class FastlyLogParser
      def initialize(io)
        @iostream = io
      end

      # Parse the Fastly log file and return a list of image hashes
      # @return [Array] An array of hashes containg namespace and image_hash per image property (empty array if none found)
      def image_hashes
        @iostream.each_line.flat_map { |line| line_hash(line) }.compact
      end

      private

      def line_hash(line)
        if hash_match = line.match(%r{(\w+)/((?:\w{3}/){3}\w{23})})
          {
            namespace: hash_match[1],
            image_hash: hash_match[2].gsub('/', '')
          }
        elsif id_match = line.match(%r{(\w+)/processing/(\d+)})
          {
            namespace: id_match[1],
            id: id_match[2]
          }
        end
      rescue
      end
    end
  end
end
