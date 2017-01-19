module Mumukit::Nuntius::EventConsumer

  class << self

    def start(name)
      Mumukit::Nuntius::Consumer.start "#{name}-events", 'events' do |_delivery_info, properties, body|
        handle_event(name, properties, body)
      end
    end

    def handle_event(name, properties, body)
      return if body[:data][:sender] == Mumukit::Nuntius.config.app_name

      choose_event(name, properties).execute!(body[:data])
    rescue NoMethodError => e
      log_exception(name, properties, e)
    rescue NameError => _
      log_unknown_event(name, properties)
    rescue => e
      log_exception(name, properties, e)
    end

    def choose_event(name, properties)
      event_name(name, properties).constantize
    end

    def event_name(name, properties)
      "#{name.capitalize}::Event::#{properties[:type]}"
    end

    def log_unknown_event(name, properties)
      Mumukit::Nuntius::Logger.info "#{event_name(name, properties)} does not exists."
    end

    def log_exception(name, properties, e)
      Mumukit::Nuntius::Logger.error "Failed to proccess #{event_name(name, properties)}, error was: #{e}"
    end
  end
end
