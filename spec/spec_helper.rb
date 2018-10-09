$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mumukit/nuntius'
require 'mumukit/core/rspec'


Mumukit::Nuntius.configure do  |config|
  config.notification_mode = Mumukit::Nuntius::NotificationMode::Deaf.new
end
