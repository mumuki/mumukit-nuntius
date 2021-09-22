module Mumukit::Nuntius::NotificationMode
  class Nuntius
    def notify!(queue_name, event)
      Mumukit::Nuntius::Publisher.publish queue_name, event
    end

    def notify_job!(type, data)
      Mumukit::Nuntius::JobPublisher.publish type, data
    end

    def notify_event!(type, data, **options)
      Mumukit::Nuntius::EventPublisher.publish type, data, **options
    end

    def establish_connection
      Mumukit::Nuntius::Connection.establish_connection
    end
  end
end
