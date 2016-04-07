class Mumukit::Nuntius::Connection

  class << self

    def config
      @config ||= YAML.load(ERB.new(File.read(File.expand_path '../../../config/rabbit.yml', __FILE__)).result).
          with_indifferent_access[ENV['RACK_ENV'] || 'development']
    end

    def start(queue_name)
      connection = Bunny.new(host: config[:host], user: config[:user], password: config[:password])
      channel = connection.start.create_channel
      queue = channel.queue(queue_name, durable: true)
      [connection, channel, queue]
    end
  end
end
