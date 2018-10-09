require_relative './spec_helper'

describe Mumukit::Nuntius do
  let(:publisher) { Mumukit::Nuntius::Publisher.new :cocina }

  it 'method missing' do
    expect(Mumukit::Nuntius.config.notification_mode).to receive(:notify!)
    publisher.notify! 'foo', foo: 'bar'
  end

  it 'method missing' do
    expect(Mumukit::Nuntius.config.notification_mode).to receive(:notify_event!).with(:cocina, 'foo', foo: 'bar')
    publisher.notify_event! 'foo', foo: 'bar'
  end
end
