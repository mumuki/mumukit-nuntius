module Mumukit::Nuntius::Consumer

	class << self

    def start(queue_name, &block)
      connection, channel, queue = Mumukit::Nuntius::Connection.start(queue_name)
      channel.prefetch(1)

      begin
        subscribe queue, channel, &block
      rescue Interrupt => _
        channel.close
        connection.close
      end
    end

    def subscribe(queue, channel, &block)
      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        begin
          block.call delivery_info, properties, JSON.parse(body)
          channel.ack(delivery_info.delivery_tag)
        rescue => e
          Mumukit::Nuntius::Logger.warn "Failed to read body: #{e.message} \n #{e.backtrace}"
          channel.persistent_publish(body, delivery_info.routing_key)
          channel.nack(delivery_info.delivery_tag, requeue: true)
        end
      end
    end
	end
end
