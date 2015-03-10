require 'yaml'
require 'lapine'

Dir.glob(File.expand_path('../publishers/*.rb', __FILE__)).each { |publisher| require publisher }

module RubyImageServer
  module Publishers
    class << self
      def configure!(config_path)
        publisher_config = YAML.load_file(config_path)

        Lapine.add_connection 'rabbitmq', {
            host: publisher_config['connection']['host'],
            port: publisher_config['connection']['port'],
            user: publisher_config['connection']['username'],
            password: publisher_config['connection']['password'],
            vhost: publisher_config['connection']['vhost'],
            ssl: publisher_config['connection']['ssl'],
            heartbeat: 10
          }

        exchange = publisher_config['exchange']
        Lapine.add_exchange exchange, {
            durable: true,
            connection: 'rabbitmq',
            type: 'topic'
          }
      end
    end
  end
end
