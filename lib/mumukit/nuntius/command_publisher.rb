module Mumukit::Nuntius::CommandPublisher

  class << self

    def publish(command, payload)
      Mumukit::Nuntius::Publisher.publish "commands", { data: payload }.merge(type: command)
    end

  end
end
