require_relative './spec_helper'

describe Mumukit::Nuntius do

  it 'method missing' do
    expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Nuntius).to receive(:notify!)
    Mumukit::Nuntius.notify! 'foo', foo: 'bar'
  end
end
