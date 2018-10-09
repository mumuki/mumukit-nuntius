class Mumukit::Nuntius::Consumer
  def initialize(component_name)
    @logger = Mumukit::Nuntius.logger_for(component_name)
  end

  def start(queue_name, exchange_name, &block)
    @logger.info "Attaching to queue #{queue_name}"
    Mumukit::Nuntius::Connection.establish_connection
    channel, exchange = Mumukit::Nuntius::Connection.start_channel(exchange_name)
    queue = channel.queue(queue_name, durable: true)
    queue.bind(exchange)
    channel.prefetch(1)

    begin
      subscribe queue, channel, &block
    rescue Interrupt => _
      @logger.info "Leaving queue #{queue_name}"
    ensure
      channel.close
    end
  end

  def subscribe(queue, channel, &block)
    @logger.debug "Subscribed to queue #{queue}"

    queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
      @logger.debug "Processing message #{body}"
      handle_message channel, delivery_info, properties, body, &block
    end
  end

  def handle_message(channel, delivery_info, properties, body, &block)
    block.call delivery_info, properties, parse_body(body)
    channel.ack delivery_info.delivery_tag
  rescue => e
    @logger.warn "Failed to read body: #{e.message} \n #{e.backtrace}"
    channel.nack delivery_info.delivery_tag, false, true
  end

  def parse_body(body)
    JSON.parse(body).with_indifferent_access
  end
end
