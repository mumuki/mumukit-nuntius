require 'mumukit/core'

require 'bunny'
require 'logger'

module Mumukit
  module Nuntius
    def self.configure
      @config ||= defaults
      yield @config
    end

    def self.config
      @config
    end

    def self.defaults
      struct.tap do |config|
        config.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
      end
    end
  end
end

require 'mumukit/nuntius/version'
require 'mumukit/nuntius/connection'
require 'mumukit/nuntius/channel'
require 'mumukit/nuntius/publisher'
require 'mumukit/nuntius/consumer'
require 'mumukit/nuntius/event_consumer'
require 'mumukit/nuntius/notification_mode'
