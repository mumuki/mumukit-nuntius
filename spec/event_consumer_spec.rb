require_relative './spec_helper'

describe Mumukit::Nuntius::EventConsumer do
  let(:component) { Mumukit::Nuntius::Component.new 'TestApp' }
  let(:event_consumer) { Mumukit::Nuntius::EventConsumer.new(component) }
  describe '#handle' do
    context 'when single handle' do
      before do
        event_consumer.handle { event(:DynamicEvent) { |data| 2 } }
      end
      it { expect(event_consumer.handles? :DynamicEvent).to be true }
      it { expect(event_consumer.handles? :OtherEvent).to be false }
    end

    context 'when multiple handles' do
      before do
        event_consumer.handle { event(:DynamicEvent) { |data| 2 } }
        event_consumer.handle do
          event(:OtherEvent) { |data| 2 }
          event(:OtherMoreEvent) { |data| 2 }
          event('OtherStringEvent') { |data| 2 }
        end
      end

      it { expect(event_consumer.handled_events).to eq %w(OtherEvent OtherMoreEvent OtherStringEvent) }

      it { expect(event_consumer.handles? :DynamicEvent).to be false }
      it { expect(event_consumer.handles? :OtherEvent).to be true }
      it { expect(event_consumer.handles? :OtherMoreEvent).to be true }
      it { expect(event_consumer.handles? 'OtherMoreEvent').to be true }
      it { expect(event_consumer.handles? 'OtherStringEvent').to be true }
      it { expect(event_consumer.handles? :OtherStringEvent).to be true }
    end
  end

  describe '#handle_event!!' do
    let(:receptor) { double('receptor') }
    before { event_consumer.register_handlers! UserChanged: proc { |data| receptor.process!(data) } }

    context 'when sender is not present' do
      before { expect(receptor).to receive(:process!).with(foo: 'bar', bar: 'baz') }

      it { event_consumer.handle_event!({type: :UserChanged},
                                                         {'data' => {'foo' => 'bar', 'bar' => 'baz'}}.with_indifferent_access) }
    end


    context 'when sender is a different application' do
      before { expect(receptor).to receive(:process!).with(foo: 'bar', bar: 'baz') }

      it { event_consumer.handle_event!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'Baz',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end

    context 'when sender is same application' do
      before { expect(receptor).to_not receive(:process!) }

      it { event_consumer.handle_event!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'TestApp',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end
  end
end

