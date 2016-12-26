module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload)
      payload.merge!(sender: ENV['MUMUKI_APPLICATION_NAME'])
      Mumukit::Nuntius::Publisher.publish "events", { data: payload }, { type: event }
    end

  end
end
