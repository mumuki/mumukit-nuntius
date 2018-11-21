module Mumukit::Nuntius::Consumer

  class << self

    def start(queue_name, exchange_name, &block)
      Mumukit::Nuntius::Logger.info "Attaching to queue #{queue_name}"
      Mumukit::Nuntius::Connection.establish_connection
      channel, exchange = Mumukit::Nuntius::Connection.start_channel(exchange_name)
      queue = channel.queue(queue_name, durable: true)
      queue.bind(exchange)
      channel.prefetch(1)

      begin
        subscribe queue, channel, &block
      rescue Interrupt => _
        Mumukit::Nuntius::Logger.info "Leaving queue #{queue_name}"
      ensure
        channel.close
      end
    end

    def negligent_start!(queue_name, &block)
      start queue_name, queue_name do |_delivery_info, _properties, body|
        begin
          block.call(body)
        rescue => e
          Mumukit::Nuntius::Logger.error "#{queue_name} item couldn't be processed #{e}. body was: #{body}"
        end
      end
    end

    def subscribe(queue, channel, &block)
      Mumukit::Nuntius::Logger.debug "Subscribed to queue #{queue}"

      queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
        Mumukit::Nuntius::Logger.debug "Processing message #{body}"
        handle_message channel, delivery_info, properties, body, &block
      end
    end

    def handle_message(channel, delivery_info, properties, body, &block)
      block.call delivery_info, properties, parse_body(body)
      channel.ack delivery_info.delivery_tag
    rescue => e
      Mumukit::Nuntius::Logger.warn "Failed to read body: #{e.message} \n #{e.backtrace}"
      channel.nack delivery_info.delivery_tag, false, true
    end

    def parse_body(body)
      JSON.parse(body).with_indifferent_access
    end
  end
end
