require_relative './spec_helper'

describe Mumukit::Nuntius do
  it { expect(Mumukit::Nuntius.config.app_name).to eq 'TestApp' }
  it { expect(Mumukit::Nuntius::VERSION).not_to be nil }
end
