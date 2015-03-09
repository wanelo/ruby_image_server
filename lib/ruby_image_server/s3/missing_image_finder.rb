require 'aws-sdk'
require 'ruby_image_server/s3/fastly_log_parser'

module RubyImageServer
  module S3
    # In Fastly, we have 404s logged and shipped to S3. We then want to process those
    # logs and attempt to reprocess the images that are missing or weren't processed
    # correctly.
    class MissingImageFinder
      private

      attr_reader :s3, :bucket, :base_path

      public

      # @param [Hash] opts option hash
      # @option opts [Aws::S3::Client] :s3 S3 client
      # @option opts [String] :bucket Bucket containing log files
      # @option opts [String] :base_path Path to log files
      def initialize(s3: Aws::S3::Client.new, bucket: '', base_path: '/')
        @s3 = s3
        @bucket = bucket
        @base_path = base_path
      end

      # @return [Array] list of unique image hashes
      def image_data
        log_objects.flat_map do |object_path|
          file = s3.get_object(bucket: bucket, key: object_path).body
          next unless file
          FastlyLogParser.new(file).image_hashes
        end.uniq
      end

      def cleanup
        log_objects.each do |object_path|
          s3.delete_object(bucket: bucket, key: object_path)
        end
      end

      private

      def log_objects
        @log_objects ||= s3.list_objects(bucket: bucket, prefix: base_path).contents.map(&:key)
      end
    end
  end
end
