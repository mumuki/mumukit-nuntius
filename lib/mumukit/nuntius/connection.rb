class Mumukit::Nuntius::Connection

  class << self
    def config
      @config ||= YAML.load_interpolated(File.expand_path '../../../../config/rabbit.yml', __FILE__).
          with_indifferent_access[ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development']
    end

    def start_channel(exchange_name)
      raise 'Nuntius connection isn\'t established' unless connected?
      channel = @connection.start.create_channel
      exchange = channel.fanout(exchange_name)
      [channel, exchange]
    end

    def establish_connection
      raise 'Nuntius connection already established' if connected?
      @connection = Bunny.new(host: config[:host], port: config[:port], user: config[:user], password: config[:password])
    end

    def connected?
      @connection.present?
    end
  end
end
