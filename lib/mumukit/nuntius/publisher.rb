class Mumukit::Nuntius::Publisher

  class << self

    def publish(queue_name, data)
      connection, channel, queue = Mumukit::Nuntius::Connection.start(queue_name)
      channel.default_exchange.publish(data.to_json, :routing_key => queue_name, persistent: true)
      connection.close
    end

    def method_missing(name, *args, &block)
      if name.to_s.starts_with? 'publish_'
        queue_name = name.to_s.split('publish_').last
        publish queue_name, args
      else
        super
      end
    end
  end
end
