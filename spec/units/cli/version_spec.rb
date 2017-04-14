require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::Version }

  let(:described_instance) { described_class.new }

  context '#__print_version' do
    subject { -> { described_instance.__print_version } }

    it { is_expected.to output(/#{Pulsar::VERSION}/).to_stdout }
  end
end
