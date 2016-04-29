require 'active_support/all'

require 'bunny'
require 'logger'


module Mumukit
  module Nuntius
    Logger = ::Logger.new('nuntius.log')
  end
end

require 'mumukit/nuntius/version'
require 'mumukit/nuntius/connection'
require 'mumukit/nuntius/channel'
require 'mumukit/nuntius/publisher'
require 'mumukit/nuntius/consumer'

