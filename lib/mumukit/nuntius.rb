require 'mumukit/core'

require 'bunny'
require 'logger'

module Mumukit
  module Nuntius
    Logger = ::Logger.new('nuntius.log')

    def self.configure
      @config ||= OpenStruct.new
      yield @config
    end

    def self.config
      @config
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