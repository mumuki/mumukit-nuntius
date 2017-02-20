require_relative './spec_helper'

module TestApp
  module Event
    extend Mumukit::Nuntius::EventConsumer::Handler
    define_handler :DynamicEvent do |data|
      2
    end
  end
end

describe Mumukit::Nuntius::EventConsumer do
  describe '#define_handler' do
    it { expect(TestApp::Event::DynamicEvent.execute!(nil)).to eq 2 }
  end

  describe '#handle_event!' do
    before { class_double('Foo::Event::UserChanged').as_stubbed_const(transfer_nested_constants: true) }


    context 'when sender is not present' do
      before { expect(Foo::Event::UserChanged).to receive(:execute!).with(foo: 'bar', bar: 'baz') }

      it { Mumukit::Nuntius::EventConsumer.handle_event(:foo,
                                                        {type: :UserChanged},
                                                        {'data' => {'foo' => 'bar', 'bar' => 'baz'}}.with_indifferent_access) }
    end


    context 'when sender is a different application' do
      before { expect(Foo::Event::UserChanged).to receive(:execute!).with(foo: 'bar', bar: 'baz') }

      it { Mumukit::Nuntius::EventConsumer.handle_event(:foo,
                                                        {type: :UserChanged},
                                                        {'data' => {
                                                            'sender' => 'Baz',
                                                            'foo' => 'bar',
                                                            'bar' => 'baz'}}.with_indifferent_access) }
    end

    context 'when sender is same application' do
      before { expect(Foo::Event::UserChanged).to_not receive(:execute!) }

      it { Mumukit::Nuntius::EventConsumer.handle_event(:foo,
                                                        {type: :UserChanged},
                                                        {'data' => {
                                                            'sender' => 'TestApp',
                                                            'foo' => 'bar',
                                                            'bar' => 'baz'}}.with_indifferent_access) }
    end
  end
end

