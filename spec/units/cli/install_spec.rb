require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::Install }

  let(:described_instance) { described_class.new }

  context '#install' do
    let(:result) { spy }

    before do
      allow(Pulsar::Install).to receive(:call).and_return(result)
      allow($stdout).to receive(:puts)
    end

    context 'calls Pulsar::Install with ./pulsar-conf by default' do
      before { described_instance.install }

      it { is_expected.to have_received(:call).with(directory: './pulsar-conf') }
    end

    context 'calls Pulsar::Install with an argument' do
      before { described_instance.install('./a-dir') }

      it { is_expected.to have_received(:call).with(directory: './a-dir') }
    end

    context 'success' do
      subject { -> { described_instance.install } }

      let(:result) { spy(success?: true) }

      it { is_expected.to output(/Successfully created intial repo!/).to_stdout }
    end

    context 'failure' do
      subject { -> { described_instance.install } }

      let(:result) { spy(success?: false) }

      it { is_expected.to output(/Failed to create intial repo./).to_stdout }
    end
  end
end
