require 'mumukit/core'

require 'bunny'
require 'logger'

module Mumukit
  module Nuntius
    Logger = ::Logger.new('nuntius.log')

    def self.configure
      @config ||= defaults
      yield @config
    end

    def self.defaults
      struct.tap do |config|
        config.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
      end
    end

    def self.config
      @config
    end

    def self.notify!(queue_name, data)
      notification_mode.notify! queue_name, data
    end

    def self.notify_event!(data, type)
      notification_mode.notify_event! data, type
    end

    private

    def self.notification_mode
      Mumukit::Nuntius.config.notification_mode
    end
  end
end

require 'mumukit/nuntius/version'
require 'mumukit/nuntius/connection'
require 'mumukit/nuntius/channel'
require 'mumukit/nuntius/publisher'
require 'mumukit/nuntius/consumer'
require 'mumukit/nuntius/event_consumer'
require 'mumukit/nuntius/event_publisher'
require 'mumukit/nuntius/notification_mode'
