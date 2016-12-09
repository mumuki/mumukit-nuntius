module Mumukit::Nuntius::Consumer

  class << self

    def start(queue_name, exchange_name, &block)
      Mumukit::Nuntius::Logger.info "Attaching to queue #{queue_name}"

      connection, channel, exchange = Mumukit::Nuntius::Connection.start(exchange_name)
      queue = channel.queue(queue_name, durable: true)
      queue.bind(exchange)
      channel.prefetch(1)

      begin
        subscribe queue, channel, &block
      rescue Interrupt => _
        Mumukit::Nuntius::Logger.info "Leaving queue #{queue_name}"
      ensure
        channel.close
        connection.close
      end
    end

    def subscribe(queue, channel, &block)
      Mumukit::Nuntius::Logger.debug "Subscribed to queue #{queue}"

      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        Mumukit::Nuntius::Logger.debug "Processing message #{body}"

        begin
          block.call delivery_info, properties, JSON.parse(body)
          channel.ack(delivery_info.delivery_tag)
        rescue => e
          Mumukit::Nuntius::Logger.warn "Failed to read body: #{e.message} \n #{e.backtrace}"
          channel.nack(delivery_info.delivery_tag, false, true)
        end
      end
    end
  end
end
