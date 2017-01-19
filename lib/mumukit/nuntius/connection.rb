class Mumukit::Nuntius::Connection

  class << self

    def config
      @config ||= YAML.load_interpolated(File.expand_path '../../../../config/rabbit.yml', __FILE__).
          with_indifferent_access[ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development']
    end

    def start(exchange_name)
      connection = Bunny.new(host: config[:host], user: config[:user], password: config[:password])
      channel = connection.start.create_channel
      exchange = channel.fanout(exchange_name)
      [connection, channel, exchange]
    end
  end
end
