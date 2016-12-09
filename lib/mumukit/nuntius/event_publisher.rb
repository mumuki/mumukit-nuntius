module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload)
      Mumukit::Nuntius::Publisher.publish "events", data: payload, type: event
    end

  end
end
