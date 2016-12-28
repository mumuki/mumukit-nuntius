module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload)
      payload.merge!(sender: Mumukit::Nuntius.config.app_name)
      Mumukit::Nuntius::Publisher.publish "events", { data: payload }, { type: event }
    end

  end
end
