module Mumukit::Nuntius::Publisher

  class << self

    def publish(exchange_name, data, opts={})
      channel, exchange = Mumukit::Nuntius::Connection.start_channel(exchange_name)
      exchange.publish(data.to_json, opts.merge(persistent: true))
      channel.close
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
