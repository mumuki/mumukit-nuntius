class Mumukit::Nuntius::Connection

  class << self
    def config
      @config ||= YAML.load_interpolated(File.expand_path '../../../../config/rabbit.yml', __FILE__).
          with_indifferent_access[ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development']
    end

    def start_channel(exchange_name)
      raise 'Nuntius connection isn\'t established' unless @connection
      channel = @connection.start.create_channel
      exchange = channel.fanout(exchange_name)
      [channel, exchange]
    end

    def establish_connection
      @connection = Bunny.new(host: config[:host], user: config[:user], password: config[:password])
    end
  end
end
