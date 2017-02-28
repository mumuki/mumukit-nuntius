require_relative './spec_helper'

describe Mumukit::Nuntius::EventConsumer do
  describe '#handle' do
    context 'when single handle' do
      before do
        Mumukit::Nuntius::EventConsumer.handle { event(:DynamicEvent) { |data| 2 } }
      end
      it { expect(Mumukit::Nuntius::EventConsumer.handles? :DynamicEvent).to be true }
      it { expect(Mumukit::Nuntius::EventConsumer.handles? :OtherEvent).to be false }
    end

    context 'when multiple handles' do
      before do
        Mumukit::Nuntius::EventConsumer.handle { event(:DynamicEvent) { |data| 2 } }
        Mumukit::Nuntius::EventConsumer.handle do
          event(:OtherEvent) { |data| 2 }
          event(:OtherMoreEvent) { |data| 2 }
        end
      end

      it { expect(Mumukit::Nuntius::EventConsumer.handled_events).to eq [:OtherEvent, :OtherMoreEvent] }

      it { expect(Mumukit::Nuntius::EventConsumer.handles? :DynamicEvent).to be false }
      it { expect(Mumukit::Nuntius::EventConsumer.handles? :OtherEvent).to be true }
      it { expect(Mumukit::Nuntius::EventConsumer.handles? :OtherMoreEvent).to be true }
    end
  end

  describe '#handle_event!!' do
    let(:receptor) { double('receptor') }
    before { Mumukit::Nuntius::EventConsumer.register_handlers! UserChanged: proc { |data| receptor.process!(data) } }

    context 'when sender is not present' do
      before { expect(receptor).to receive(:process!).with(foo: 'bar', bar: 'baz') }

      it { Mumukit::Nuntius::EventConsumer.handle_event!({type: :UserChanged},
                                                         {'data' => {'foo' => 'bar', 'bar' => 'baz'}}.with_indifferent_access) }
    end


    context 'when sender is a different application' do
      before { expect(receptor).to receive(:process!).with(foo: 'bar', bar: 'baz') }

      it { Mumukit::Nuntius::EventConsumer.handle_event!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'Baz',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end

    context 'when sender is same application' do
      before { expect(receptor).to_not receive(:process!) }

      it { Mumukit::Nuntius::EventConsumer.handle_event!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'TestApp',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end
  end
end

