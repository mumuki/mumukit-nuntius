module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload, **options)
      payload.merge!(sender: Mumukit::Nuntius.config.app_name).merge!(options)
      Mumukit::Nuntius::Publisher.publish "events", {data: payload}, {type: event}
    end

  end
end
