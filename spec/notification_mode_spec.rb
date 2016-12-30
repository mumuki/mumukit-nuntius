require_relative './spec_helper'

describe Mumukit::Nuntius::NotificationMode do

  context 'test env' do
    before { ENV['RACK_ENV'] = 'test' }
    it { expect(Mumukit::Nuntius::NotificationMode.from_env).to be_a Mumukit::Nuntius::NotificationMode::Deaf }
  end

  context 'queueless mode' do
    before { ENV['QUEUELESS_MODE'] = 'true' }
    it { expect(Mumukit::Nuntius::NotificationMode.from_env).to be_a Mumukit::Nuntius::NotificationMode::Deaf }
  end

  context 'production env' do
    before do
      ENV['RACK_ENV'] = 'production'
      ENV['TEST_ENV'] = 'production'
      ENV['QUEUELESS_MODE'] = nil
    end

    skip { expect(Mumukit::Nuntius::NotificationMode.from_env).to be_a Mumukit::Nuntius::NotificationMode::Nuntius }
  end
end
