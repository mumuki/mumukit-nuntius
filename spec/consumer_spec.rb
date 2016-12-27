require_relative './spec_helper'

describe Mumukit::Nuntius::Consumer do
  describe 'parse_body' do
    let(:parsed_body) { Mumukit::Nuntius::Consumer.parse_body '{"data":{"foo":"bar"}}' }

    it { expect(parsed_body).to eq 'data' => {'foo' => 'bar'} }
    it { expect(parsed_body[:data][:foo]).to eq 'bar' }
  end
end
