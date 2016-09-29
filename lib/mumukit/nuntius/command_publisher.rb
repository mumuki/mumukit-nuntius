module Mumukit::Nuntius::CommandPublisher

  class << self

    def publish(destination, command, payload)
      Mumukit::Nuntius::Publisher.publish "#{destination}-commands", { data: payload }.merge(type: command)
    end

  end
end
