require_relative './spec_helper'

describe Mumukit::Nuntius::Consumer do
  describe 'parse_body' do
    let(:parsed_body) { Mumukit::Nuntius::Consumer.parse_body '{"data":{"foo":"bar"}}' }

    it { expect(parsed_body).to eq 'data' => {'foo' => 'bar'} }
    it { expect(parsed_body[:data][:foo]).to eq 'bar' }
  end

  describe 'handle_message' do
    let(:channel) { double('channel') }
    let(:delivery_options) { struct(delivery_tag: 'a12345bcd') }

    context 'when message handling fails internally' do
      before { expect(channel).to receive :nack }
      it { Mumukit::Nuntius::Consumer.handle_message(channel, delivery_options, {}, 'dadasd') }
    end

    context 'when message handling fails on block' do
      before { expect(channel).to receive :nack }
      it { Mumukit::Nuntius::Consumer.handle_message(channel, delivery_options, {}, '{"data":{"foo":"bar"}') { raise 'oops' } }
    end

    context 'when message handling succeeds' do
      before { expect(channel).to receive :ack }
      it { Mumukit::Nuntius::Consumer.handle_message(channel, delivery_options, {}, '{"data":{"foo":"bar"}}') {} }
    end
  end
end
