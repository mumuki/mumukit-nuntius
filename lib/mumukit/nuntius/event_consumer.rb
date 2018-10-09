class Mumukit::Nuntius::EventConsumer
  class Builder
    def initialize
      @handlers = {}
    end

    def event(key, &block)
      @handlers[key] = block
    end

    def build
      @handlers.with_indifferent_access
    end
  end

  def initialize(component_name)
    @handlers = {}
    @component_name = component_name
    @logger = Mumukit::Nuntius.logger_for(component_name)
  end

  def handle(&block)
    register_handlers! Builder.new.tap { |it| it.instance_eval(&block) }.build
  end

  def handled_events
    @handlers.keys
  end

  def register_handlers!(handlers)
    @handlers = handlers
  end

  def handles?(event)
    @handlers.include? event
  end

  def start!
    queue_name = "#{@component_name}-events"
    consumer.start queue_name, 'events' do |_delivery_info, properties, body|
      handle_event!(properties, body)
    end
  end

  def handle_event!(properties, body)
    return if body[:data][:sender] == @component_name
    event = properties[:type]
    if handles? event
      @handlers[event].call body[:data].except(:sender)
    else
      log_unknown_event event
    end
  rescue => e
    log_exception(event, e)
  end

  private

  def consumer
    Mumukit::Nuntius::Consumer.new(@component_name)
  end


  def log_unknown_event(event)
    @logger.info "Unhandled event: #{event} does not exists."
  end

  def log_exception(event, e)
    @logger.error "Failed to proccess #{event}, error was: #{e}"
  end
end
