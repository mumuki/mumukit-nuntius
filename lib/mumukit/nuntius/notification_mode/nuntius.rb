module Mumukit::Nuntius::NotificationMode
  class Nuntius
    def notify!(queue_name, event)
      Mumukit::Nuntius::Publisher.publish queue_name, event
    end

    def notify_event!(type, data)
      Mumukit::Nuntius::EventPublisher.publish type, data
    end
  end
end
