class RubyImageServerCLI < Thor
  desc 'version', 'show ruby_image_server version'
  def version
    puts "ruby_image_server #{RubyImageServer::VERSION}"
  end
end
