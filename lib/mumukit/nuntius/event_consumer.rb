module Mumukit::Nuntius::EventConsumer

  class << self

    def start(name)
      Mumukit::Nuntius::Consumer.start "#{name}-events", 'events' do |_delivery_info, properties, body|
        next if body['sender'] == Mumukit::Nuntius.config.app_name
        begin
          choose_event(name, properties).execute!(body['data'])
        rescue NoMethodError => e
          log_exception(name, properties, e)
        rescue NameError => e
          log_unknown_event(name, properties)
        rescue => e
          log_exception(name, properties, e)
        end
      end
    end

    def choose_event(name, properties)
      event_name(name, properties).constantize
    end

    def event_name(name, properties)
      "#{name.capitalize}::Event::#{properties[:type]}"
    end

    def log_unknown_event(name, properties)
      Mumukit::Nuntius::Logger.error "#{event_name(name, properties)} does not exists."
    end

    def log_exception(name, properties, e)
      Mumukit::Nuntius::Logger.error "Failed to proccess #{event_name(name, properties)}, error was: #{e}"
    end
  end
end
