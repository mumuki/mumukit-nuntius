$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mumukit/nuntius'

Mumukit::Nuntius.configure do  |config|
  config.app_name = 'TestApp'
  config.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
end