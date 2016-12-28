require 'mumukit/nuntius/notification_mode/deaf'
require 'mumukit/nuntius/notification_mode/nuntius'

module Mumukit::Nuntius::NotificationMode
  extend ConfigurableGlobal

  def self.get_current
    deaf? ? NotificationMode::Deaf.new : NotificationMode::Nuntius.new
  end

  private

  def self.deaf?
    Rails.configuration.queueless_mode
  end
end
