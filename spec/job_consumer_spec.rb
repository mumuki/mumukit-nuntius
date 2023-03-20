require_relative './spec_helper'

describe Mumukit::Nuntius::JobConsumer do
  describe '#handle' do
    context 'when single handle' do
      before do
        Mumukit::Nuntius::JobConsumer.handle { job(:DynamicJob) { |data| 2 } }
      end
      it { expect(Mumukit::Nuntius::JobConsumer.handles? :DynamicJob).to be true }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? :OtherJob).to be false }
    end

    context 'when multiple handles' do
      before do
        Mumukit::Nuntius::JobConsumer.handle { job(:DynamicJob) { |data| 2 } }
        Mumukit::Nuntius::JobConsumer.handle do
          job(:OtherJob) { |data| 2 }
          job(:OtherMoreJob) { |data| 2 }
          job('OtherStringJob') { |data| 2 }
        end
      end

      it { expect(Mumukit::Nuntius::JobConsumer.handled_jobs).to eq %w(OtherJob OtherMoreJob OtherStringJob) }

      it { expect(Mumukit::Nuntius::JobConsumer.handles? :DynamicJob).to be false }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? :OtherJob).to be true }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? :OtherMoreJob).to be true }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? 'OtherMoreJob').to be true }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? 'OtherStringJob').to be true }
      it { expect(Mumukit::Nuntius::JobConsumer.handles? :OtherStringJob).to be true }
    end
  end

  describe '#handle_job!!' do
    let(:receptor) { double('receptor') }
    before { Mumukit::Nuntius::JobConsumer.register_handlers! UserChanged: proc { |data| receptor.process!(data) } }

    context 'when sender is not present' do
      before { expect(receptor).to receive(:process!).with({foo: 'bar', bar: 'baz'}) }

      it { Mumukit::Nuntius::JobConsumer.handle_job!({type: :UserChanged},
                                                         {'data' => {'foo' => 'bar', 'bar' => 'baz'}}.with_indifferent_access) }
    end


    context 'when sender is a different application' do
      before { expect(receptor).to_not receive(:process!).with({foo: 'bar', bar: 'baz'}) }

      it { Mumukit::Nuntius::JobConsumer.handle_job!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'Baz',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end

    context 'when sender is same application' do
      before { expect(receptor).to receive(:process!) }

      it { Mumukit::Nuntius::JobConsumer.handle_job!({type: :UserChanged},
                                                         {'data' => {
                                                             'sender' => 'TestApp',
                                                             'foo' => 'bar',
                                                             'bar' => 'baz'}}.with_indifferent_access) }
    end
  end
end
