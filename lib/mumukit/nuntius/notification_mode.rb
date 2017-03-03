require 'mumukit/nuntius/notification_mode/deaf'
require 'mumukit/nuntius/notification_mode/nuntius'

module Mumukit::Nuntius::NotificationMode

  def self.from_env
    if ENV['MUMUKI_QUEUELESS_MODE'].present? || ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
      Mumukit::Nuntius::NotificationMode::Deaf.new
    else
      Mumukit::Nuntius::NotificationMode::Nuntius.new
    end
  end
end
