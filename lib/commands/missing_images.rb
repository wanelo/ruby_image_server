require 'ruby_image_server/s3/missing_image_finder'
require 'ruby_image_server/publishers'

class RubyImageServerCLI < Thor
  desc 'missing_images BUCKET PATH', 'find and enqueue missing images for reprocessing'

  method_option :lapine_config, type: :string, default: 'settings/lapine.yml'
  method_option :dry_run, type: :boolean, default: false
  method_option :verbose, type: :boolean, default: false
  def missing_images(bucket, path)
    RubyImageServer::Publishers.configure!(options[:lapine_config])

    finder = RubyImageServer::S3::MissingImageFinder.new(bucket: bucket, base_path: path)
    finder.image_data.each do |datum|
      puts "Publishing: #{datum[:image_hash]}" if puts?
      RubyImageServer::Publishers::MissingImage.new(namespace: datum[:namespace], image_hash: datum[:image_hash]).publish('images.missing') unless dry_run?
    end
    puts "Cleaning up..." if puts?
    finder.cleanup unless options[:dry_run]
  end

  private

  def puts?
    options[:verbose] || dry_run?
  end

  def dry_run?
    options[:dry_run]
  end
end
