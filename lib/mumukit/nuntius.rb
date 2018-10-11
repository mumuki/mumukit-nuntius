require 'mumukit/core'

require 'bunny'
require 'logger'

module Mumukit
  module Nuntius
    def self.configure
      @config ||= defaults
      yield @config
      raise 'app_name is no longer supported' if @config['app_name']
    end

    def self.config
      @config
    end

    def self.defaults
      struct.tap do |config|
        config.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
      end
    end

    def self.logger_for(component_name)
      ::Logger.new("#{component_name}.nuntius.log")
    end
  end
end

require 'mumukit/nuntius/version'
require 'mumukit/nuntius/connection'
require 'mumukit/nuntius/channel'
require 'mumukit/nuntius/publisher'
require 'mumukit/nuntius/consumer'
require 'mumukit/nuntius/component'
require 'mumukit/nuntius/event_consumer'
require 'mumukit/nuntius/notification_mode'
