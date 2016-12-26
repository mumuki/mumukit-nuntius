module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload, action='')
      payload.merge!(sender: Mumukit::Nuntius.config.app_name)
      Mumukit::Nuntius::Publisher.publish "events", { data: payload, action: action }, { type: event }
    end

  end
end
