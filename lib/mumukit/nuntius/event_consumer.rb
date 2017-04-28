module Mumukit::Nuntius::EventConsumer
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

  class << self
    @@handlers = {}

    def handle(&block)
      register_handlers! Builder.new.tap { |it| it.instance_eval(&block) }.build
    end

    def handled_events
      @@handlers.keys
    end

    def register_handlers!(handlers)
      @@handlers = handlers
    end

    def start!
      queue_name = "#{Mumukit::Nuntius.config.app_name}-events"
      Mumukit::Nuntius::Consumer.start queue_name, 'events' do |_delivery_info, properties, body|
        handle_event!(properties, body)
      end
    end

    def handles?(event)
      @@handlers.include? event
    end

    def handle_event!(properties, body)
      return if body[:data][:sender] == Mumukit::Nuntius.config.app_name
      event = properties[:type]
      if handles? event
        @@handlers[event].call body[:data].except(:sender)
      else
        log_unknown_event event
      end
    rescue => e
      log_exception(event, e)
    end

    def log_unknown_event(event)
      Mumukit::Nuntius::Logger.info "Unhandled event: #{event} does not exists."
    end

    def log_exception(event, e)
      Mumukit::Nuntius::Logger.error "Failed to proccess #{event}, error was: #{e}"
    end
  end
end
