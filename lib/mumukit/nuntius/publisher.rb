module Mumukit::Nuntius::Publisher

  class << self

    def publish(queue_name, data)
      connection, channel, queue = Mumukit::Nuntius::Connection.start(queue_name)
      channel.persistent_publish(data.to_json, queue_name)
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
