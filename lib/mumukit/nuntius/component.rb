module Mumukit::Nuntius
  class Component
    attr_accessor :name

    delegate :notify!, :notify_event!, to: :publisher

    def initialize(name)
      @name = name
    end

    def logger
      @logger ||= Mumukit::Nuntius.logger_for(@name)
    end

    def consumer
      @consumer ||= Mumukit::Nuntius::Consumer.new(self)
    end

    def event_consumer
      @event_consumer ||= Mumukit::Nuntius::EventConsumer.new(self)
    end

    private

    def publisher
      @publisher ||= Mumukit::Nuntius::Publisher.new(self).tap(&:establish_connection)
    end
  end
end
