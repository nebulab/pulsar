require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::CLI }

  context '#install' do
    it 'calls Pulsar::Organizers::Install with . by default' do
      allow(Pulsar::Install).to receive(:call)
      subject.new.install

      expect(Pulsar::Install).to have_received(:call).with(directory: '.')
    end

    it 'calls Pulsar::Organizers::Install with argument' do
      allow(Pulsar::Install).to receive(:call)
      subject.new.install('./a-dir')

      expect(Pulsar::Install).to have_received(:call).with(directory: './a-dir')
    end
  end
end
