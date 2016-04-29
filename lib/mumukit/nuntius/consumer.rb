module Mumukit::Nuntius::Consumer

	class << self

    def start(queue_name)
      connection, channel, queue = Mumukit::Nuntius::Connection.start(queue_name)
      channel.prefetch(1)

      begin
        subscribe queue, channel
      rescue Interrupt => _
        channel.close
        connection.close
      end
    end

    def subscribe(queue, channel)
      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        begin
          yield delivery_info, properties, JSON.parse(body).first
          channel.ack(delivery_info.delivery_tag)
        rescue => e
          Mumukit::Nuntius::Logger.warn "Failed to read body: #{e.message} \n #{e.backtrace}"
        end
      end
    end
	end
end
