module Mumukit::Nuntius::Publisher

  class << self

    def publish(exchange_name, data)
      connection, channel, exchange = Mumukit::Nuntius::Connection.start(exchange_name)
      exchange.publish(data.to_json, persistent: true)
      connection.close
    end

    def method_missing(name, *args, &block)
      if name.to_s.starts_with? 'publish_'
        queue_name = name.to_s.split('publish_').last
        publish queue_name, *args
      else
        super
      end
    end
  end
end
