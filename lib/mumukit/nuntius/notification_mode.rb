require 'mumukit/nuntius/notification_mode/deaf'
require 'mumukit/nuntius/notification_mode/nuntius'

module Mumukit::Nuntius::NotificationMode

  def self.from_env
    ENV['QUEUELESS_MODE'] ? Mumukit::Nuntius::NotificationMode::Deaf.new : Mumukit::Nuntius::NotificationMode::Nuntius.new
  end
end
