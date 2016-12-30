require_relative './spec_helper'

describe Mumukit::Nuntius do

  it 'method missing' do
    expect(Mumukit::Nuntius.config.notification_mode).to receive(:notify!)

    Mumukit::Nuntius.notify! 'foo', foo: 'bar'
  end
end
