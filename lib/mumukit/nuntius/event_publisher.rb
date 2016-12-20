module Mumukit::Nuntius::EventPublisher

  class << self

    def publish(event, payload, action='')
      payload.merge!(sender: ENV['MUMUKI_APPLICATION_NAME'])
      Mumukit::Nuntius::Publisher.publish "events", { data: payload, action: action }, { type: event }
    end

  end
end
