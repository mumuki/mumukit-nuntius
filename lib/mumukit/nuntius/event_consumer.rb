module Mumukit::Nuntius::EventConsumer

  class << self

    def start(name)
      Mumukit::Nuntius::Consumer.start "#{name}-events", 'events' do |_delivery_info, _properties, body|
        begin
          choose_event(name, body).execute!(body['data'])
        rescue NoMethodError => e
          log_exception(name, body, e)
        rescue NameError => e
          log_unkown_event(name, body)
        rescue => e
          log_exception(name, body, e)
        end
      end
    end

    def choose_event(name, body)
      event_name(name, body).constantize
    end

    def event_name(name, body)
      "#{name.capitalize}::Event::#{body['type']}"
    end

    def log_unkown_event(name, body)
      Mumukit::Nuntius::Logger.error "#{event_name(name, body)} does not exists."
    end

    def log_exception(name, body, e)
      Mumukit::Nuntius::Logger.error "Failed to proccess #{event_name(name, body)}, error was: #{e}"
    end
  end
end
