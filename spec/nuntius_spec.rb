require_relative './spec_helper'

describe Mumukit::Nuntius do

  it 'method missing' do
    expect(Mumukit::Nuntius.config.notification_mode).to receive(:notify!)

    Mumukit::Nuntius.notify! 'foo', foo: 'bar'
  end

  describe Mumukit::Nuntius::NotificationMode::Nuntius do
    let(:nuntius_connection) { Mumukit::Nuntius::NotificationMode::Nuntius.new }
    before { allow(Mumukit::Nuntius).to receive(:notification_mode).and_return(nuntius_connection) }

    context '.establish_connection' do
      it 'does not allow establishing connection twice' do
        expect { 2.times { Mumukit::Nuntius.establish_connection } }.to raise_error RuntimeError
      end
    end

    context '.ensure_connection' do
      it 'does not break when called twice' do
        expect { 2.times { Mumukit::Nuntius.ensure_connection } }.to_not raise_error
      end
    end
  end
end
