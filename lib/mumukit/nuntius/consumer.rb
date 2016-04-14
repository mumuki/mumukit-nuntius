class Mumukit::Nuntius::Consumer

	class << self

    def start(queue_name)
      connection, channel, queue = Mumukit::Nuntius::Connection.start(queue_name)
      channel.prefetch(1)

      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        begin
          yield delivery_info, properties, JSON.parse(body).first
          channel.ack(delivery_info.delivery_tag)
        rescue Interrupt => _
          channel.close
          connection.close
        end
      end
    end
	end
end
