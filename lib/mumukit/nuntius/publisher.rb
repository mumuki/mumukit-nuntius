module Mumukit::Nuntius
  class Publisher
    def initialize(component)
      @component = component
    end

    # Notifies a message to a given queue.
    #
    # Messages are consumed using the Mumukit::Nuntius::Consumer module
    #
    # @param [String|Symbol] queue_name the name of the queue to which publish this message
    # @param [Hash] message a json-like hash with the message data.
    def notify!(queue_name, message)
      notification_mode.notify! queue_name, message
    end

    # Notifies an event of the given type.
    #
    # Events are very similar to normal messages, with the following differences:
    #
    #   * they are published to a single queue, named `events`
    #   * event data is augmented with the sender app name,
    #     so that consumers can discard events sent from themselves.
    #
    # This makes events lighter and easier to send. You should send application
    # events to here unless:
    #
    #   * you expect to send alot of those events
    #   * you expect those events processing to be slow
    #
    # Events are consumed using the Mumukit::Nuntius::EventConsumer module
    #
    # @param [String|Symbol] type the type of event.
    # @param [Hash] event a json-like hash with the event data
    def notify_event!(type, event)
      notification_mode.notify_event! @component.name, type, event
    end

    def establish_connection
      notification_mode.establish_connection
    end

    private

    def notification_mode
      Mumukit::Nuntius.config.notification_mode
    end
  end
end
